[#ftl]

[#macro azure_s3_arm_state occurrence parent={}]
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local storageAccountId = formatResourceId(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.Id)]
    [#local containerId = formatResourceId( AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, core.Id )]
    [#local blobId = formatResourceId( AZURE_BLOBSERVICE_RESOURCE_TYPE, core.Id )]

    [#local publicAccessEnabled = false]
    [#list solution.PublicAccess?values as publicPrefixConfiguration]
        [#if publicPrefixConfiguration.Enabled]
            [#local publicAccessEnabled = true]
            [#break]
        [/#if]
    [/#list]

    [#-- Process Resource Naming Conditions                                             --]
    [#-- Note: it is a requirement that the blobService name is "default" in all cases. --]
    [#-- https://tinyurl.com/yxozph9o                                                   --]
    [#local accountName = formatName(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.ShortName)]
    [#local blobName = "default"]
    [#local containerName = formatName(AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, core.ShortName)]
    [#local accountName = formatAzureResourceName(accountName, AZURE_STORAGEACCOUNT_RESOURCE_TYPE)]
    [#local blobName = formatAzureResourceName(blobName, AZURE_BLOBSERVICE_RESOURCE_TYPE, accountName)]
    [#local containerName = formatAzureResourceName(containerName, AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, blobName)]

    [#assign componentState=
        {
            "Resources" : {
                "storageAccount" : {
                    "Id" : storageAccountId,
                    "Name" : accountName,
                    "Type" : AZURE_STORAGEACCOUNT_RESOURCE_TYPE
                },
                "blobService" : {
                    "Id" : blobId,
                    "Name" : blobName,
                    "Type" : AZURE_BLOBSERVICE_RESOURCE_TYPE
                },
                "container" : {
                    "Id" : containerId,
                    "Name" : containerName,
                    "Type" : AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE
                }
            },
            "Attributes" : {
                "ACCOUNT_ID" : storageAccountId,
                "ACCOUNT_NAME" : getExistingReference(storageAccountId, NAME_ATTRIBUTE_TYPE),
                "CONTAINER_NAME" : getExistingReference(containerId, NAME_ATTRIBUTE_TYPE),
                "WEBSITE_URL" : getExistingReference(storageAccountId, URL_ATTRIBUTE_TYPE)
            },
            "Roles" : {
                [#-- TODO(rossmurr4y): impliment appropriate roles. --]
                "Inbound" : {},
                "Outbound" : {
                    [#-- "all" : storageAllPermission(id) --]
                }
            }
        }
    ]
[/#macro]