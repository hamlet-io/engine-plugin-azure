[#ftl]

[#macro azure_s3_arm_state occurrence parent={} baseState={}]
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local storageAccountId = formatResourceId(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.Id)]
    [#local containerId = formatResourceId( AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, core.Id )]
    [#local blobId = formatResourceId( AZURE_BLOBSERVICE_RESOURCE_TYPE, core.Id )]
    [#local publicAccessEnabled = false]
    [#list solution.publicAccess?values as publicPrefixConfiguration]
        [#if publicPrefixConfiguration.Enabled]
            [#local publicAccessEnabled = true]
            [#break]
        [/#if]
    [/#list]

    [#assign componentState=
        {
            "Resources" : {
                "storageAccount" : {
                    "id" : storageAccountId,
                    "type" : AZURE_STORAGEACCOUNT_RESOURCE_TYPE
                },
                "blobService" : {
                    "id" : blobId,
                    "type" : AZURE_BLOBSERVICE_RESOURCE_TYPE
                },
                "container" : {
                    "id" : containerId,
                    "type" : AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE
                }
            },
            "Attributes" : {
                "ACCOUNT_NAME" : getExistingReference(storageAccountId, NAME_ATTRIBUTE_TYPE),
                "CONTAINER_NAME" : getExistingReference(containerId, NAME_ATTRIBUTE_TYPE),
                "BLOB_NAME" : getExistingReference(blobId, NAME_ATTRIBUTE_TYPE),
                "WEBSITE_URL" : getExistingReference(id, URL_ATTRIBUTE_TYPE)
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