[#ftl]

[#macro azure_sqs_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#-- Baseline component lookup --]
    [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData" ], false, false)]
    [#local baselineAttributes = baselineLinks["OpsData"].State.Attributes]

    [#local storageAccount = baselineAttributes["ACCOUNT_NAME"]]
    [#local queueUrl = baselineAttributes["QUEUE_ENDPOINT"]]
    [#local queueId = formatResourceId(AZURE_QUEUE_RESOURCE_TYPE, core.Id)]
    [#local queueName = formatAzureResourceName(core.ShortTypedName, getResourceType(queueId))]
    [@debug message="baselineLinks" context=baselineLinks enabled=false /]
    [#assign componentState =
        {
            "Resources" : {
                "queue" : {
                    "Id" : queueId,
                    "Name" : queueName,
                    "Type" : AZURE_QUEUE_RESOURCE_TYPE,
                    "StorageAccount": storageAccount
                }
            },
            "Attributes" : {
                "NAME" : queueName,
                "URL": formatRelativePath(queueUrl, queueName)
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]

[/#macro]