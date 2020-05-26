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
    [#local container = formatName(AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, core.ShortName)]
    [#local accountName = formatAzureResourceName(accountName, AZURE_STORAGEACCOUNT_RESOURCE_TYPE)]
    [#local blobName = formatAzureResourceName(blobName, AZURE_BLOBSERVICE_RESOURCE_TYPE, accountName)]
    [#local containerName = formatAzureResourceName(container, AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, blobName)]

    [#local storageEndpoints = 
        getExistingReference(
            formatId(
                storageAccountId
                "properties",
                "primaryEndpoints"
            )
        )
    ]

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
                "ACCOUNT_NAME" : accountName,
                "CONTAINER_NAME" : container,
                "PRIMARY_ENDPOINT" : contentIfContent(storageEndpoints.blob, ""),
                "QUEUE_ENDPOINT": contentIfContent(storageEndpoints.queue, ""),
                "WEB_ENDPOINT": contentIfContent(storageEndpoints.web, "")
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]
[/#macro]