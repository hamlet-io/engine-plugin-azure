[#ftl]

[#macro azure_baseline_arm_solution occurrence]
  [@debug message="Entering" context=occurrence enabled=false /]

    [#if deploymentSubsetRequired("genplan", false)]
      [@addDefaultGenerationPlan subsets="template" /]
      [#return]
    [/#if]

    [#local core = occurrence.Core ]
    [#local solution = occurrence.Configuration.Solution ]
    [#local resources = occurrence.State.Resources ]
    [#local links = getLinkTargets(occurrence )]

    [#-- make sure we only have one occurence --]
    [#if  ! ( core.Tier.Id == "mgmt" &&
      core.Component.Id == "baseline" &&
      core.Version.Id == "" &&
      core.Instance.Id == "" ) ]

      [@fatal
        message="The baseline component can only be deployed once as an unversioned component"
        context=core
      /]
      [#return ]
    [/#if]

    [#-- Baseline component lookup --]
    [#local baselineLinks = getBaselineLinks(occurrence, [ "Encryption" ], false, false )]
    [#local baselineComponentIds = getBaselineComponentIds(baselineLinks)]
    [#local cmkKeyId = baselineComponentIds["Encryption"]]
    [@debug message={ "KeyId" : cmkKeyId } enabled=false /]

    [#-- Parent Component Resources --]
    [#local tenantId = accountObject.AWSId]
    [#local accountId = resources["storageAccount"].Id]
    [#local blobServiceId = resources["blobService"].Id]
    [#local keyvaultId = resources["keyVault"].Id]
    [#local keyVaultAccessPolicy = resources["keyVaultAccessPolicy"].Id]

    [#-- storageAccount : Retrieve Certificate Information --]
    [#local certificateObject = getCertificateObject(solution.Certificate, segmentQualifiers, sourcePortId, sourcePortName) ]
    [#local primaryDomainObject = getCertificatePrimaryDomain(certificateObject) ]
    [#local fqdn = formatDomainName(hostName, primaryDomainObject)]

    [#-- storageAccount + keyVault : Retrieve NetworkACL Configuration --]
    [#-- networkAcls object is used for both Storage Account and KeyVault --]
    [#local virtualNetworkRulesConfiguration = []]
    [#local cidrs = getGroupCIDRs(solution.IPAddressGroups)]

    [#list solution.IPAddressGroups as subnet]
      [#local virtualNetworkRulesConfiguration += getNetworkAclsVirtualNetworkRules(
        id=(getExistingReference(formatResourceId(AZURE_NETWORK_RESOURCE_TYPE, subnet)).id)
        action="Allow"
      )]
    [/#list]

    [#local ipRulesConfiguration = []]
    [#list cidrs as cidr]
      [#local ipRulesConfiguration += getNetworkAclsIpRules(
        value=cidr
        action="Allow"
      )]
    [/#list]

    [#local networkAclsConfiguration = getNetworkAcls(
      defaultAction="Deny"
      ipRules=ipRulesConfiguration
      virtualNetworkRules=virtualNetworkRulesConfiguration
      bypass="None"
    )]

    [@createStorageAccount
      name=accountId
      sku=getStorageSku(storageProfile.Tier, storageProfile.Replication)
      location=regionId
      customDomain=getStorageCustomDomain(fqdn)
      networkAcls=networkAclsConfiguration
      accessTier=(storageProfile.AccessTier!{})
      azureFilesIdentityBasedAuthentication=
        (solution.Access.DirectoryService)?has_content?then(
          getStorageAzureFilesIdentityBasedAuthentication(solution.Access.DirectoryService),
          {}
        )
      isHnsEnabled=(storageProfile.HnsEnabled!false)
    /]

    [@createBlobService 
      name=blobServiceId
      CORSBehaviours=solution.CORSBehaviours
      deleteRetentionPolicy=
        (solution.Lifecycle.BlobRetentionDays)?has_content?then(
          getStorageBlobServiceDeleteRetentionPolicy(solution.Lifecycle.BlobRetentionDays),
          {}
        )
      automaticSnapshotPolicyEnabled=(solution.Lifecycle.BlobAutoSnapshots!false)
    /]

    [@createKeyVault
      name=keyvaultId
      location=regionId
      properties=
        getKeyVaultProperties(
          tenantId=tenantId
          sku=getKeyVaultSku("A", "standard")
          enabledForDeployment=true
          enabledForDiskEncryption=true
          enableSoftDelete=true
          createMode="default"
          enablePurgeProtection=true
          networkAcls=networkAclsConfiguration
        )
    /]

    [#-- Subcomponents --]
    [#list occurrence.Occurrences![] as subOccurrence]

      [#local subCore = subOccurrence.Core]
      [#local subSolution = subOccurrence.Configuration.Solution]
      [#local subResources = subOccurrence.State.Resources]

      [#-- storage containers --]
      [#if subCore.Type == BASELINE_DATA_COMPONENT_TYPE]
        [#local containerName = subResources["container"].Name]

        [#if ( deploymentSubsetRequired(BASELINE_COMPONENT_TYPE, true)]

          [#if subSolution.Role == "appdata"]
            [#local publicAccess = dataPublicEnabled]
          [#else]
            [#local publicAccess = false]
          [/#if]

          [@createBlobServiceContainer
            name=containerName
            publicAccess=publicAccess
            dependsOn=
              [ 
                accountId,
                blobId 
              ]
          /]
        [/#if]
      [/#if]

      [#-- Keys --]
      [#if subCore.Type == BASELINE_KEY_COMPONENT_TYPE]

        [#switch subSolution.Engine]
          [#case "cmk"]

            [#local localKeyPairId = subResources["cmkLocalKeyPair"].Id]
            [#local localKeyPairPublicKey = subResources["cmkLocalKeyPair"].PublicKey]
            [#local localKeyPairPrivateKey = subResources["cmkLocalKeyPair"].PrivateKey]
            [#local keyPairId = subResources["cmkKeyPair"].Id]
            [#local keyPairName = subResources["cmkKeyPair"].Name]
            [#local keyVaultName = subResources["cmkKeyPair"].Vault]

            [#if deploymentSubsetRequired("epilogue")]

              [#-- Generate & Import CMK into keyvault --]
              [@addToDefaultBashScriptOutput 
                content=[
                  "function az_manage_cmk_credentials() {"
                  "  info \"Checking CMK credentials ...\"",
                  "  #",
                  "  # Create CMK credential for the segment",
                  "  mkdir -p \"$\{SEGMENT_OPERATIONS_DIR}\"",
                  "  az_create_pki_credentials \"$\{SEGMENT_OPERATIONS_DIR}\" " +
                      "\"" + regionId + "\" " +
                      "\"" + accountObject.Id + "\" " +
                      " cmk || return $?",
                  "  #",
                  "  # Update the credential if required",
                  "  if ! az_check_key_credentials" + " " +
                      "\"" + keyVaultName + "\" " +
                      "\"" + keyPairName + "\"; then",
                  "    pem_file=\"$\{SEGMENT_OPERATIONS_DIR}/" + localKeyPairPublicKey + "\"",
                  "    az_update_key_credentials" + " " +
                      "\"" + keyVaultName + "\" " +
                      "\"" + keyPairName + "\" " +
                      "\"$\{pem_file}\" || return $?",
                  "   [[ -f \"$\{SEGMENT_OPERATIONS_DIR}/" + localKeyPairPrivateKey + ".plaintext\" ]] && ",
                  "      { encrypt_file" + " " +
                          "\"" + regionId + "\"" + " " +
                          "\"" + keyPairId + "\"" + " " +
                          "\"$\{SEGMENT_OPERATIONS_DIR}/" + localKeyPairPrivateKey + ".plaintext\"" + " " +
                          "\"$\{SEGMENT_OPERATIONS_DIR}/" + localKeyPairPrivateKey + "\" || return $?; }",
                  "  fi",
                  "  #"
                ] +
                pseudoARMStackOutputScript(
                  "CMK Key Pair",
                  {
                    keyPairId : keyPairName,
                    formatId(keyVaultName, "Name") : keyVaultName
                  },
                  "cmk"
                ) +
                [
                  "  #",
                  "  az_show_key_credentials" + " " +
                      "\"" + keyVaultName + "\" " +
                      "\"" + keyPairName + "\" ",
                  "  #",
                  "  return 0"
                  "}",
                  "#",
                  "# Determine the required key pair name",
                  "key_pair_name=\"" + keyPairName + "\"",
                  "#",
                  "case $\{STACK_OPERATION} in",
                  "  delete)",
                  "    az_delete_key_credentials " + " " +
                    "\"" + keyVaultName + "\" " +
                    "\"$\{key_pair_name}\" || return $?",
                  "    az_delete_pki_credentials \"$\{SEGMENT_OPERATIONS_DIR}\" " +
                        "\"" + regionId + "\" " +
                        "\"" + accountObject.Id + "\" " +
                        " cmk || return $?",
                  "    rm -f \"$\{CF_DIR}/$(fileBase \"$\{BASH_SOURCE}\")-keypair-pseudo-stack.json\"",
                  "    ;;",
                  "  create|update)",
                  "    az_manage_cmk_credentials || return $?",
                  "    ;;",
                  "esac"
                ]
              /]

            [/#if]
          [#break]
          [#case "ssh"]

            [#local localKeyPairId = subResources["sshLocalKeyPair"].Id]
            [#local localKeyPairPublicKey = subResources["sshLocalKeyPair"].PublicKey]
            [#local localKeyPairPrivateKey = subResources["sshLocalKeyPair"].PrivateKey]
            [#local vmKeyPairId = subResources["vmKeyPair"].Id]
            [#local vmKeyPairName = subResources["vmKeyPair"].Name]
            [#local vmKeyVaultName = subResources["vmKeyPair"].Vault]

            [#if deploymentSubsetRequired("epilogue")]

              [#-- Generate & Import SSH credentials into keyvault --]
              [@addToDefaultBashScriptOutput 
                content=[
                  "function az_manage_ssh_credentials() {"
                  "  info \"Checking SSH credentials ...\"",
                  "  #",
                  "  # Create SSH credential for the segment",
                  "  mkdir -p \"$\{SEGMENT_OPERATIONS_DIR}\"",
                  "  az_create_pki_credentials \"$\{SEGMENT_OPERATIONS_DIR}\" " +
                      "\"" + regionId + "\" " +
                      "\"" + accountObject.Id + "\" " +
                      " ssh || return $?",
                  "  #",
                  "  # Update the credential if required",
                  "  if ! az_check_key_credentials" + " " +
                      "\"" + vmKeyVaultName + "\" " +
                      "\"" + vmKeyPairName + "\"; then",
                  "    pem_file=\"$\{SEGMENT_OPERATIONS_DIR}/" + localKeyPairPublicKey + "\"",
                  "    az_update_key_credentials" + " " +
                      "\"" + vmKeyVaultName + "\" " +
                      "\"" + vmKeyPairName + "\" " +
                      "\"$\{pem_file}\" || return $?",
                  "   [[ -f \"$\{SEGMENT_OPERATIONS_DIR}/" + localKeyPairPrivateKey + ".plaintext\" ]] && ",
                  "      { encrypt_file" + " " +
                          "\"" + regionId + "\"" + " " +
                          "\"" + cmkKeyId + "\"" + " " +
                          "\"$\{SEGMENT_OPERATIONS_DIR}/" + localKeyPairPrivateKey + ".plaintext\"" + " " +
                          "\"$\{SEGMENT_OPERATIONS_DIR}/" + localKeyPairPrivateKey + "\" || return $?; }",
                  "  fi",
                  "  #"
                ] +
                pseudoARMStackOutputScript(
                  "SSH Key Pair",
                  {
                    vmKeyPairId : vmKeyPairName,
                    formatId(vmKeyVaultName, "Name") : vmKeyVaultName
                  },
                  "keypair"
                ) +
                [
                  "  #",
                  "  az_show_key_credentials" + " " +
                      "\"" + vmKeyVaultName + "\" " +
                      "\"" + vmKeyPairName + "\" ",
                  "  #",
                  "  return 0"
                  "}",
                  "#",
                  "# Determine the required key pair name",
                  "key_pair_name=\"" + vmKeyPairName + "\"",
                  "#",
                  "case $\{STACK_OPERATION} in",
                  "  delete)",
                  "    az_delete_key_credentials " + " " +
                    "\"" + vmKeyVaultName + "\" " +
                    "\"$\{key_pair_name}\" || return $?",
                  "    az_delete_pki_credentials \"$\{SEGMENT_OPERATIONS_DIR}\" " +
                        "\"" + regionId + "\" " +
                        "\"" + accountObject.Id + "\" " +
                        " ssh || return $?",
                  "    rm -f \"$\{CF_DIR}/$(fileBase \"$\{BASH_SOURCE}\")-keypair-pseudo-stack.json\"",
                  "    ;;",
                  "  create|update)",
                  "    az_manage_ssh_credentials || return $?",
                  "    ;;",
                  "esac"
                ]
              /]
            [/#if]
          [#break]
        [/#switch]
      [/#if]
    [/#list]
[/#macro]