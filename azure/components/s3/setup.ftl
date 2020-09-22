[#ftl]
[#macro azure_s3_arm_deployment_generationcontract occurrence]
    [@addDefaultGenerationContract subsets="template" /]
[/#macro]

[#macro azure_s3_arm_deployment occurrence]

    [#local core = occurrence.Core ]
    [#local solution = occurrence.Configuration.Solution ]
    [#local resources = occurrence.State.Resources ]
    [#local links = getLinkTargets(occurrence )]

    [#local accountId = resources["storageAccount"].Id]
    [#local blobId = resources["blobService"].Id]
    [#local containerId = resources["container"].Id]
    [#local secret = resources["secret"]]

    [#local accountName = resources["storageAccount"].Name]
    [#local blobName = resources["blobService"].Name]
    [#local containerName = resources["container"].Name]

    [#local storageProfile = getStorage(occurrence, "storageAccount")]

    [#-- Baseline Links --]
    [#local baselineLinks = getBaselineLinks(occurrence, ["SSHKey"], false, false)]
    [#local baselineAttributes = baselineLinks["SSHKey"].State.Attributes]
    [#local keyVaultId = baselineAttributes["KEYVAULT_ID"]]
    [#local keyVaultName = getExistingReference(keyVaultId, NAME_ATTRIBUTE_TYPE)]

    [#-- Add NetworkACL Configuration --]
    [#local virtualNetworkRulesConfiguration = []]
    [#list solution.PublicAccess?values as publicAccessConfiguration]

        [#local storageCIDRs = getGroupCIDRs(publicAccessConfiguration.IPAddressGroups)]

    [/#list]


    [#local ipRulesConfiguration = []]
    [#list storageCIDRs as cidr]
        [#local ipRulesConfiguration += asArray(getStorageNetworkAclsIpRules(cidr, "Allow"))]
    [/#list]


    [#local ipRulesConfiguration = []]
    [#local networkAclsConfiguration = getStorageNetworkAcls("Deny", ipRulesConfiguration, virtualNetworkRulesConfiguration, "AzureServices")]

    [#-- Retrieve Certificate Information --]
    [#if solution.Certificate?has_content]
        [#local certificateObject = getCertificateObject(solution.Certificate, segmentQualifiers, sourcePortId, sourcePortName) ]
        [#local primaryDomainObject = getCertificatePrimaryDomain(certificateObject) ]
        [#local fqdn = formatDomainName(hostName, primaryDomainObject)]
    [#else]
        [#local fqdn = ""]
    [/#if]

    [#if deploymentSubsetRequired("s3", true)]

        [@createStorageAccount
            id=accountId
            name=accountName
            kind=storageProfile.Type
            sku=getStorageSku(storageProfile.Tier, storageProfile.Replication)
            location=regionId
            customDomain=fqdn?has_content?then(
                getStorageCustomDomain(fqdn),
                {})
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
            id=blobId
            name=blobName
            CORSBehaviours=solution.CORSBehaviours
            deleteRetentionPolicy=
                (solution.Lifecycle.BlobRetentionDays)?has_content?then(
                    getStorageBlobServiceDeleteRetentionPolicy(solution.Lifecycle.BlobRetentionDays),
                    {}
                )
            automaticSnapshotPolicyEnabled=(solution.Lifecycle.BlobAutoSnapshots!false)
            resources=[]
            dependsOn=
                [
                    getReference(accountName)
                ]
        /]

        [@createBlobServiceContainer
            id=containerId
            name=containerName
            publicAccess=solution.PublicAccess.Enabled
            dependsOn=
                [
                    getReference(accountName),
                    getReference(blobName)
                ]
        /]

        [#-- Set ConnectionKey as Secret --]
        [@createKeyVaultSecret
            id=secret.Id
            name=formatAzureResourceName(
                secret.Name,
                secret.Type,
                keyVaultName)
            parentId=keyVaultId
            properties=
                getKeyVaultSecretProperties(
                    formatAzureStorageListKeys(accountName)
                )
            dependsOn=[
                getReference(accountName)
            ]
        /]

    [/#if]

[/#macro]
