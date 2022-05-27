[#ftl]
[#macro azure_baseline_arm_deployment_generationcontract occurrence]
  [@addDefaultGenerationContract subsets=["prologue", "template", "epilogue"] /]
[/#macro]

[#macro azure_baseline_arm_deployment occurrence]
    [@debug message="Entering" context=occurrence enabled=false /]

    [#local core = occurrence.Core ]
    [#local solution = occurrence.Configuration.Solution ]
    [#local resources = occurrence.State.Resources ]
    [#local links = getLinkTargets(occurrence )]
    [#local keyVaultIPRuleGroups = []]
    [#local keyVaultAdmins = solution["azure:AdministratorGroups"]![] ]

    [#-- make sure we only have one occurrence --]
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
    [#if !(getReference(segmentSeedId)?has_content)]

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
      "cmk",
      "vmKeyPair")]
    [#local cmkKeyId = baselineComponentIds["Encryption"]]

    [#-- Parent Component Resources --]
    [#local tenantId = formatAzureSubscriptionReference("tenantId")]
    [#local accountId = resources["storageAccount"].Id]
    [#local secret = resources["secret"]]
    [#local accountName = resources["storageAccount"].Name]
    [#local blobId = resources["blobService"].Id]
    [#local blobName = resources["blobService"].Name]
    [#local webContainerDefault = resources["webContainerDefault"] ]
    [#local keyvault = resources["keyVault"]]
    [#local keyVaultAccessPolicy = resources["keyVaultAccessPolicy"].Id]
    [#local registries = resources["registries"]]

    [#local storageProfile = getStorage(occurrence, "storageAccount", solution.Profiles["azure:Storage"])]

    [#-- storageAccount : Retrieve Certificate Information --]
    [#if solution.Certificate?has_content]
      [#local certificateObject = getCertificateObject(solution.Certificate) ]
      [#local primaryDomainObject = getCertificatePrimaryDomain(certificateObject) ]
      [#local fqdn = formatDomainName(hostName, primaryDomainObject)]
    [#else]
        [#local fqdn = ""]
    [/#if]

    [#--
      storageAccount + keyVault : Retrieve NetworkACL Configuration
      Default network access to keyvault and storageAccounts is to Allow. Restricting
      these services is expected to occur through authentication.
    --]
    [#-- networkAcls object is used for both Storage Account and KeyVault --]
    [#local storageNetworkAclsConfiguration = getNetworkAcls("Allow", [], [], "AzureServices")]

    [@createStorageAccount
      id=accountId
      name=accountName
      kind=storageProfile.Type
      sku=getStorageSku(storageProfile.Tier, storageProfile.Replication)
      location=getRegion()
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

    [#-- Set ConnectionKey as Secret --]
    [@createKeyVaultSecret
        id=secret.Id
        name=formatAzureResourceName(
            secret.Name,
            secret.Type,
            keyvault.Name)
        properties=
            getKeyVaultSecretProperties(
                formatAzureStorageListKeys(accountId, accountName)
            )
        dependsOn=[
            getReference(accountId, accountName),
            getReference(keyvault.Id, keyvault.Name)
        ]
    /]

    [@createBlobService
      id=blobId
      name=blobName
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

    [#-- Create All Registry Containers --]
    [#list registries?values as registry]

      [@createBlobServiceContainer
        id=registry.Id
        name=registry.Name
        publicAccess="None"
        dependsOn=
          [
            getReference(accountId, accountName),
            getReference(blobId, blobName)
          ]
      /]
    [/#list]

    [#-- Subcomponents --]
    [#list (occurrence.Occurrences![])?filter(x -> x.Configuration.Solution.Enabled ) as subOccurrence]

      [#local subCore = subOccurrence.Core]
      [#local subSolution = subOccurrence.Configuration.Solution]
      [#local subResources = subOccurrence.State.Resources]

      [#-- storage containers --]
      [#if subCore.Type == BASELINE_DATA_COMPONENT_TYPE]
        [#local containerId = subResources["container"].Id]
        [#local containerName = subResources["container"].Name]

        [#if (deploymentSubsetRequired(BASELINE_COMPONENT_TYPE, true))]

          [#switch subSolution.Role ]
            [#case "appdata"]
              [#local publicAccess = "Container"]
              [#break]

            [#case "operations"]
              [#local publicAccess = "Blob"]
              [#break]

            [#default]
              [#local publicAccess = "None"]
          [/#switch]

          [@createBlobServiceContainer
            id=containerId
            name=containerName
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

            [#local keyPair = subResources["cmk"]]

              [#-- Generate & Import CMK into keyvault --]

              [@createKeyVaultKey
                id=keyPair.Id
                name=formatAzureResourceName(
                      keyPair.Name,
                      AZURE_KEYVAULT_KEY_RESOURCE_TYPE,
                      keyvault.Name
                    )
                parentId=keyvault.Id
                keyType="RSA"
                keySize="2048"
                dependsOn=[getReference(keyvault.Id, keyvault.Name)]
              /]

          [#break]
          [#case "ssh"]

            [#local localKeyPairId = subResources["localKeyPair"].Id]
            [#local localKeyPairPublicKey = subResources["localKeyPair"].PublicKey]
            [#local localKeyPairPrivateKey = subResources["localKeyPair"].PrivateKey]

            [#local vmKeyPair = subResources["vmKeyPair"]]

            [#if deploymentSubsetRequired("epilogue")]

              [#-- Generate & Import SSH credentials into keyvault --]

              [@addToDefaultBashScriptOutput
                content=[
                  r'function az_manage_ssh_credentials() {',
                  r'  info "Checking SSH credentials ..."',
                  r'  #',
                  r'  # Create SSH credential for the segment',
                  r'  mkdir -p "${SEGMENT_OPERATIONS_DIR}"',
                  r'  az_create_ssh_keypair "${SEGMENT_OPERATIONS_DIR}" ' +
                      r'"' + getRegion() + r'" ' +
                      r'"' + accountObject.Id + r'" || return $?',
                  r'  #',
                  r'  # Upload to keyvault if required.',
                  r'  AZ_CHK_SECRET="$(az_check_secret ' +
                      r'"' + keyvault.Name + r'" "' + vmKeyPair.Name + r'PublicKey")"',
                  r'  if [[ "${AZ_CHK_SECRET}" == "does not have secrets get permission on key vault" ]]; then',
                  r'    fatal "The deployment user is not a member of the specified keyVault admin group"',
                  r'    return 1',
                  r'  fi',
                  r'  if [[ "${AZ_CHK_SECRET}" == *"NotFound"* ]]; then',
                  r'     pem_file="${SEGMENT_OPERATIONS_DIR}/' + localKeyPairPublicKey + r'.plaintext.pub"',
                  r'     az_add_secret ' +
                            r'"' + keyvault.Name + r'" ' +
                            r'"' + vmKeyPair.Name + r'PublicKey" ' +
                            r'"${pem_file}"',
                  r'  fi',
                  r'  AZ_CHK_SECRET="$(az_check_secret ' +
                  r'"' + keyvault.Name + r'" "' + vmKeyPair.Name + r'PrivateKey")"',
                  r'  if [[ "${AZ_CHK_SECRET}" == *"NotFound"* ]]; then',
                  r'     pem_file="${SEGMENT_OPERATIONS_DIR}/' + localKeyPairPrivateKey + r'.plaintext"',
                  r'     az_add_secret ' +
                            r'"' + keyvault.Name + r'" "' + vmKeyPair.Name + r'PrivateKey" "${pem_file}"',
                  r'  fi',
                  r' #'
                ] +
                pseudoArmStackOutputScript(
                  "SSH Key Pair",
                  {
                    vmKeyPair.Id : vmKeyPair.Name,
                    formatId(keyvault.Name, "Name") : keyvault.Name
                  },
                  "keypair"
                ) +
                [
                  r' return 0',
                  r'}',
                  r'#',
                  r'case ${DEPLOYMENT_OPERATION} in',
                  r'  delete)',
                  r'    AZ_CHK_SECRET="$(az_check_secret ' +
                  r'"' + keyvault.Name + r'" "' + vmKeyPair.Name + r'PublicKey" )"',
                  r'    if [[ ! ( "${AZ_CHK_SECRET}" == *"NotFound"* ) ]]; then',
                  r'      az_delete_secret "' + keyvault.Name + r'" "' + vmKeyPair.Name + r'PublicKey"',
                  r'    fi',
                  r'    AZ_CHK_SECRET="$(az_check_secret ' +
                  r'"' + keyvault.Name + r'" "' + vmKeyPair.Name + r'PrivateKey")"',
                  r'    if [[ ! ( "${AZ_CHK_SECRET}" == *"NotFound"* ) ]]; then',
                  r'      az_delete_secret "' + keyvault.Name + r'" "' + vmKeyPair.Name + r'PrivateKey"',
                  r'    fi',
                  r'    ;;',
                  r'  create|update)',
                  r'    az_manage_ssh_credentials || return $?',
                  r'   ;;',
                  r'esac'
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

    [#if deploymentSubsetRequired("prologue", false)]
      [#list keyVaultAdmins as adminGrp ]
        [#local adminId = formatId(keyvault.Id,adminGrp)]
        [@addToDefaultBashScriptOutput
          content=
          [
            r'case ${DEPLOYMENT_OPERATION} in',
            r'  create|update)',
            r'    ADMINGRP="$(az role definition list --name ' + adminGrp + r')"',
            r'    if [[ ${#ADMINGRP[@]} -eq 0 ]] ; then',
            r'      fatal "Azure Administrator role does not exist: ' + adminGrp + '"',
            r'      return 1',
            r'    fi'
          ] +
          pseudoArmStackOutputScript(
            "AdministratorGroups",
            { adminId : adminGrp },
            "admingrp"
          ) +
          [
            r'       ;;',
            r'      esac'
          ]
        /]
      [/#list]
    [/#if]

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

    [#local keyvaultAdminsId = getOccurrenceSettingValue(
      occurrence,
      [
        ["azure", "administrators", "group"],
        ["aad", "administrators", "group"],
        ["azure", "admins"],
        ["aad", "admins"],
        [productName, "administrators"],
        [productName, "admins"]
      ],
      true
    )]

   [#if ! keyVaultAdmins?has_content ]
      [@fatal
        message="No KeyVault Admins have been defined"
        context="To create a keyvault create a new group or user Id and add it to azure:AdministratorGroups"
      /]
    [/#if]

    [#local keyVaultAccessRules = []]
    [#list keyVaultAdmins as keyvaultAdmin ]

        [#local keyVaultAccessRules += [ getKeyVaultAccessPolicyObject(
        tenantId,
        keyvaultAdmin,
        defaultKeyVaultPermissions
      ) ]]
    [/#list]

    [@createKeyVault
      id=keyvault.Id
      name=keyvault.Name
      location=getRegion()
      properties=
        getKeyVaultProperties(
          tenantId,
          getKeyVaultSku("A", "standard"),
          keyVaultAccessRules,
          "",
          true,
          true,
          true,
          true,
          "default",
          false,
          getNetworkAcls("Deny", keyVaultIpRules, [], "AzureServices")
        )
    /]

[/#macro]
