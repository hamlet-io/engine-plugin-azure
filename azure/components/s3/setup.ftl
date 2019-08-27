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

    [#local accountId = resources["storageAccount"].id]
    [#local blobId = resources["blobService"].id]
    [#local containerId = resources["container"].id]

    [#local storageProfile = getStorage(occurrence, "storageAccount")]

    [#-- Baseline component lookup --]
    [#local baselineLinks = getBaselineLinks(occurrence, [ "CDNOriginKey" ])]
    [#local baselineComponentIds = getBaselineComponentIds(baselineLinks)]

    [#if deploymentSubsetRequired("s3", true)]

        [#-- TODO(rossmurr4y): Impliment tags. Currently the shared function getOccurrenceCoreTags
        in gen3\engine\common.ftl just formats a call to the function getCfTemplateCoreTags, which is aws
        provider specific. --]
        [#-- TODO(rossmurr4y): Impliment customDomain. Already have written the function getStorageCustomDomain
        however it requires a domain URL to be passed to it. --]
        [@createStorageAccount
            name=accountId
            sku=getStorageSku(storageProfile.Tier, storageProfile.Replication)
            location=regionId
            [#--customDomain=(isPresent(solution.Website))?then(getStorageCustomDomain(  ), {}) TODO --]
            [#-- encryption= TODO --]
            [#-- networkAcls= TODO --]
            [#-- accessTier= TODO --]
            [#-- azureFilesIdentityBasedAuthentication= TODO --]
            [#-- supportsHttpsTrafficOnly= TODO --]
            [#-- isHnsEnabled= TODO --]
            [#-- dependsOn= TODO --]
        ]

        [#-- TODO  
        [@createBlobServic]  
        --]

        [#-- TODO 
        [@createBlobServiceContainer]
        --]

    [/#if]

[/#macro]