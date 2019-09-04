[#ftl]

[#macro azure_s3_arm_solution occurrence]
    [@debug message="Entering" context=occurrence enabled=false /]

    [#if deploymentSubsetRequired("genplan", false)]
        [@addDefaultGenerationPlan subsets="template" /]
        [#return]
    [/#if]

    [#local core = occurrence.Core ]
    [#local solution = occurrence.Configuration.Solution ]
    [#local resources = occurrence.State.Resources ]
    [#local links = getLinkTargets(occurrence )]

    [#local accountId = resources["storageAccount"].Id]
    [#local blobId = resources["blobService"].Id]
    [#local containerId = resources["container"].Id]

    [#local storageProfile = getStorage(occurrence, "storageAccount")]

    [#-- Baseline component lookup 
    [#local baselineLinks = getBaselineLinks(occurrence, [ "CDNOriginKey" ])]
    [#local baselineComponentIds = getBaselineComponentIds(baselineLinks)] --]

    [#-- Add Encryption Configuration --]
    [#if solution.Encryption.Enabled]
        [#local encryptionConfiguration =
            getStorageEncryption(
                solution.Encryption.KeySource, 
                (getStorageEncryptionServices(
                    blob=(solution.Encryption.Services?contains("blob")),
                    file=(solution.Encryption.Services?contains("file"))
                )),
                (solution.Encryption.KeySource)?contains("Keyvault")?then(
                    getStorageEncryptionKeyvaultproperties(
                        name=(solution.Secrets.KeyName!""),
                        keyversion=(solution.Secrets.KeyVersion!""),
                        uri=(solution.Secrets.KeyUri?url!"")
                    ),
                    {}
                )
            )
        ]
    [#else]
        [#local encryptionConfiguration = {}]
    [/#if]

    [#-- Add NetworkACL Configuration --]
    [#local virtualNetworkRulesConfiguration = []]
    [#list solution.Access.SubnetIds as subnet]
        [#local virtualNetworkRulesConfiguration += getStorageNetworkAclsVirtualNetworkRules(
            id=subnet
            action="Allow"
        )]
    [/#list]
    [#local ipRulesConfiguration = []]
    [#list solution.Access.IPAddressRanges as ip]
        [#local ipRulesConfiguration += getStorageNetworkAclsIpRules(
            value=ip
            action="Allow"
        )]
    [/#list]
    [#local networkAclsConfiguration = getStorageNetworkAcls(
        defaultAction="Deny"
        ipRules=ipRulesConfiguration
        virtualNetworkRules=virtualNetworkRulesConfiguration
        bypass="None"
    )]

    [#-- TODO(rm): Add accessTier --]
    [#-- TODO(rm): Add azureFilesIdentityBasedAuthentication --]
    [#-- TODO(rm): Add supportHttpsTrafficOnly --]
    [#-- TODO(rm): Add isHnsEnabled --]
    [#-- TODO(rm): Add dependsOn --]

    [#if deploymentSubsetRequired("s3", true)]

        [#-- TODO(rossmurr4y): Impliment tags. Currently the shared function getOccurrenceCoreTags
        in gen3\engine\common.ftl just formats a call to the function getCfTemplateCoreTags, which is aws
        provider specific. --]
        [@createStorageAccount
            name=accountId
            kind=storageProfile.Type
            sku=getStorageSku(storageProfile.Tier, storageProfile.Replication)
            location=regionId
            customDomain=
                (solution.Website.CustomDomain)?has_content?then(
                    getStorageCustomDomain(solution.Website.CustomDomain),
                    {}
                )
            encryption=encryptionConfiguration
            networkAcls=networkAclsConfiguration
            [#-- accessTier= TODO --]
            [#-- azureFilesIdentityBasedAuthentication= TODO --]
            [#-- supportsHttpsTrafficOnly= TODO --]
            [#-- isHnsEnabled= TODO --]
            [#-- dependsOn= TODO --]
        /]

        [@createBlobService
            name=
        /]  

        [@createBlobServiceContainer
            name=
        /]

    [/#if]

[/#macro]