[#ftl]

[#macro azure_sqs_arm_state occurrence parent={} baseState={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#-- Baseline component lookup --]
    [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData" ], false, false)]
    [#local baselineAttributes = baselineLinks["OpsData"].State.Attributes]

    [#local storageAccount = baselineAttributes["ACCOUNT_NAME"]]
    [#local queueUrl = baselineAttributes["QUEUE_ENDPOINT"]]
    [#local queueId = formatResourceId(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.Id)]
    [#local queueName = formatAzureResourceName(core.ShortTypedName, getResourceType(queueId))]
    [@debug message="baselineLinks" context=baselineLinks enabled=true /]
    [#assign componentState =
        {
            "Resources" : {
                "queue" : {
                    "Id" : queueId,
                    "Name" : queueName,
                    "StorageAccount": storageAccount
                }
            },
            "Attributes" : {
                "URL": formatRelativePath(queueUrl, queueName)
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]

[/#macro]