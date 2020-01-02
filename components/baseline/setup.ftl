[#ftl]
[#macro azure_baseline_arm_genplan_segment occurrence]
  [@addDefaultGenerationPlan subsets=["prologue", "template", "epilogue"] /]
[/#macro]

[#macro azure_baseline_arm_setup_segment occurrence]


    [#local core = occurrence.Core ]
    [#local solution = occurrence.Configuration.Solution ]
    [#local resources = occurrence.State.Resources ]
    [#local links = getLinkTargets(occurrence )]
    [#local keyVaultIPRuleGroups = []]

    [#-- make sure we only have one occurence --]
    [#if  ! ( core.Tier.Id == "mgmt" &&
      core.Component.Id == "baseline" &&
      core.Version.Id == "" &&
      core.Instance.Id == "" ) ]

      [@fatal
        message="The baseline component can only be deployed once as an unversioned component"
        context=core
      /]
      [#return]
    [/#if]

    [#-- Segment Seed --]
    [#local segmentSeedId = resources["segmentSeed"].Id]
    [#local segmentSeedValue = resources["segmentSeed"].Value]
    [#if !(getExistingReference(segmentSeedId)?has_content)]

      [#if deploymentSubsetRequired("prologue", false)]
        [@addToDefaultBashScriptOutput
          content=
          [
            "case $\{DEPLOYMENT_OPERATION} in",
            "  create|update)"
          ] +
          pseudoArmStackOutputScript(
            "Seed Values",
            { segmentSeedId : segmentSeedValue },
            "seed"
          ) +
          [
            "       ;;",
            "       esac"
          ]
        /]
      [/#if]
    [/#if]

    [#-- Baseline component lookup --]
    [#local baselineLinks = getBaselineLinks(occurrence, [ "Encryption" ], false, false )]
    [#local baselineComponentIds = getBaselineComponentIds(
      baselineLinks,
      AZURE_CMK_RESOURCE_TYPE,
      AZURE_SSH_PRIVATE_KEY_RESOURCE_TYPE,
      "")]
    [#local cmkKeyId = baselineComponentIds["Encryption"]]

    [#-- Parent Component Resources --]
    [#local tenantId = formatAzureSubscriptionReference("tenantId")]
    [#local accountId = resources["storageAccount"].Id]
    [#local accountName = resources["storageAccount"].Name]
    [#local blobId = resources["blobService"].Id]
    [#local blobName = resources["blobService"].Name]
    [#local keyvaultId = resources["keyVault"].Id]
    [#local keyvaultName = resources["keyVault"].Name]
    [#local keyVaultAccessPolicy = resources["keyVaultAccessPolicy"].Id]

    [#-- Process Resource Naming Conditions --]
    [#local accountName = formatAzureResourceName(accountName, getResourceType(accountId))]
    [#local blobName = formatAzureResourceName(blobName, getResourceType(blobId), accountName)]

    [#local storageProfile = getStorage(occurrence, "storageAccount")]

    [#-- storageAccount : Retrieve Certificate Information --]
    [#if solution.Certificate?has_content]
      [#local certificateObject = getCertificateObject(solution.Certificate, segmentQualifiers, sourcePortId, sourcePortName) ]
      [#local primaryDomainObject = getCertificatePrimaryDomain(certificateObject) ]
      [#local fqdn = formatDomainName(hostName, primaryDomainObject)]
    [#else]
        [#local fqdn = ""]
    [/#if]

    [#--
      storageAccount + keyVault : Retrieve NetworkACL Configuration
      Component roles will grant more explicit access to Storage + KeyVault.
      For now we just want blanket "deny-all" networkAcls.
    --]
    [#-- networkAcls object is used for both Storage Account and KeyVault --]
    [#local storageNetworkAclsConfiguration = getNetworkAcls("Deny", [], [], "AzureServices")]

    [@createStorageAccount
      id=accountId
      name=accountName
      kind=storageProfile.Type
      sku=getStorageSku(storageProfile.Tier, storageProfile.Replication)
      location=regionId
      customDomain=getStorageCustomDomain(fqdn)
      networkAcls=storageNetworkAclsConfiguration
      accessTier=(storageProfile.AccessTier)!{}
      azureFilesIdentityBasedAuthentication=
        (solution.Access.DirectoryService)?has_content?then(
          getStorageAzureFilesIdentityBasedAuthentication(solution.Access.DirectoryService),
          {}
        )
      isHnsEnabled=(storageProfile.HnsEnabled)!false
    /]

    [@createBlobService
      id=blobId
      name=blobName
      accountName=accountName
      CORSBehaviours=solution.CORSBehaviours
      deleteRetentionPolicy=
        (solution.Lifecycle.BlobRetentionDays)?has_content?then(
          getStorageBlobServiceDeleteRetentionPolicy(solution.Lifecycle.BlobRetentionDays),
          {}
        )
      automaticSnapshotPolicyEnabled=(solution.Lifecycle.BlobAutoSnapshots)!false
      dependsOn=
        [
          getReference(accountId, accountName)
        ]
    /]

    [#-- Subcomponents --]
    [#list occurrence.Occurrences![] as subOccurrence]

      [#local subCore = subOccurrence.Core]
      [#local subSolution = subOccurrence.Configuration.Solution]
      [#local subResources = subOccurrence.State.Resources]

      [#-- storage containers --]
      [#if subCore.Type == BASELINE_DATA_COMPONENT_TYPE]
        [#local containerId = subResources["container"].Id]
        [#local containerName = subResources["container"].Name]

        [#-- Process Resource Naming Conditions --]
        [#local containerName = formatAzureResourceName(containerName, getResourceType(containerId), blobName)]

        [#if (deploymentSubsetRequired(BASELINE_COMPONENT_TYPE, true))]

          [#if subSolution.Role == "appdata"]
            [#local publicAccess = "Container"]
          [#else]
            [#local publicAccess = "None"]
          [/#if]

          [@createBlobServiceContainer
            id=containerId
            name=containerName
            accountName=accountName
            blobName=blobName
            publicAccess=publicAccess
            dependsOn=
              [
                getReference(accountId, accountName),
                getReference(blobId, blobName)
              ]
          /]
        [/#if]
      [/#if]

      [#-- Keys --]
      [#if subCore.Type == BASELINE_KEY_COMPONENT_TYPE]

        [#switch subSolution.Engine]
          [#case "cmk"]

            [#local keyPairId = subResources[AZURE_CMK_RESOURCE_TYPE].Id]
            [#local keyPairName = subResources[AZURE_CMK_RESOURCE_TYPE].Name]
            [#local keyVaultName = keyvaultName]

            [#if deploymentSubsetRequired("epilogue")]

              [#-- Generate & Import CMK into keyvault --]

              [@addToDefaultBashScriptOutput
                content=[
                  "function az_generate_cmk() {"
                    "az keyvault key create --kty RSA --size 2048 --vault-name \"" + keyVaultName + "\" --name \"" + keyPairName + "\"",
                    "#"
                ] +
                pseudoArmStackOutputScript(
                  "CMK Key Pair",
                  {
                    keyPairId : keyPairName,
                    formatId(keyVaultName, "Name") : keyVaultName
                  },
                  "cmk"
                ) +
                [
                  " return 0"
                  "}",
                  "#",
                  "case $\{DEPLOYMENT_OPERATION} in",
                  "  delete)",
                  "    az_delete_key_credentials \"" + keyVaultName + "\" \"" + keyPairName + "\"",
                  "    ;;",
                  "  create|update)",
                  "    az_generate_cmk || return $?",
                  "    ;;",
                  "esac"
                ]
              /]

            [/#if]
          [#break]
          [#case "ssh"]

            [#local vmKeyPairId = subResources[AZURE_SSH_PRIVATE_KEY_RESOURCE_TYPE].Id]
            [#local vmKeyPairName = subResources[AZURE_SSH_PRIVATE_KEY_RESOURCE_TYPE].Name]
            [#local vmKeyVaultName = keyvaultName]

            [#if deploymentSubsetRequired("epilogue")]
              
              [#-- Generate & Import SSH credentials into keyvault --]

              [@addToDefaultBashScriptOutput
                content=[
                  "function az_generate_ssh_private_key() {"
                    "az keyvault key create --kty RSA --size 2048 --vault-name \"" + vmKeyVaultName + "\" --name \"" + vmKeyPairName + "\"",
                    "#"
                ] +
                pseudoArmStackOutputScript(
                  "SSH Key Pair",
                  {
                    vmKeyPairId : vmKeyPairName,
                    formatId(vmKeyVaultName, "Name") : vmKeyVaultName
                  },
                  "keypair"
                ) +
                [
                  " return 0"
                  "}",
                  "#",
                  "case $\{DEPLOYMENT_OPERATION} in",
                  "  delete)",
                  "    az_delete_key_credentials \"" + vmKeyVaultName + "\" \"" + vmKeyPairName + "\"",
                  "    ;;",
                  "  create|update)",
                  "    az_generate_ssh_private_key || return $?",
                  "    ;;",
                  "esac"
                ]
              /]

            [/#if]
          [#break]
        [/#switch]

        [#-- Determine the IPAddressGroups for the KeyVault rules --]
        [#local keyVautlNetworkAddressGroups = subSolution.IPAddressGroups]
        [#list keyVautlNetworkAddressGroups as group]
          [#local keyVaultIPRuleGroups += [group]]
        [/#list]

      [/#if]
    [/#list]

    [#-- Create keyvault after generating rules --]

    [#local keyVaultIpRules = []]
    [#local keyVaultRuleCIDRs = getGroupCIDRs(getUniqueArrayElements(keyVaultIPRuleGroups))]
    [#list keyVaultRuleCIDRs as cidr]
      [#local keyVaultIpRules += [{"value" : cidr}]]
    [/#list]

    [#-- KeyVault Access Policy to allow Azure Admins access to KeyVault--]
    [#local defaultKeyVaultPermissions = getKeyVaultAccessPolicyPermissions(
      ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"],
      ["Get","List","Set","Delete","Recover","Backup","Restore"],
      ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","ManageContacts","ManageIssuers","GetIssuers","ListIssuers","SetIssuers","DeleteIssuers"]
    )]

    [#local keyVaultAccessPolicyObject = getKeyVaultAccessPolicyObject(
      tenantId,
      getExistingReference("AzureAdministratorsGroup"),
      defaultKeyVaultPermissions
    )]

    [@createKeyVault
      id=keyvaultId
      name=keyvaultName
      location=regionId
      properties=
        getKeyVaultProperties(
          tenantId,
          getKeyVaultSku("A", "standard"),
          [keyVaultAccessPolicyObject],
          "",
          true,
          true,
          true,
          false,
          "default",
          true,
          getNetworkAcls("Deny", keyVaultIpRules, [], "AzureServices")
        )
    /]

[/#macro]
