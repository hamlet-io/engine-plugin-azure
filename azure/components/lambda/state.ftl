[#ftl]

[#macro azure_lambda_arm_state occurrence parent={}]

    [#local core = occurrence.Core]

    [#assign componentState =
        {
            "Resources" : {
                "consumptionPlan" : {
                    "Id" : formatResourceId(AZURE_APP_SERVICE_PLAN_RESOURCE_TYPE, core.Id),
                    "Name" : core.FullName,
                    "Type" : AZURE_APP_SERVICE_PLAN_RESOURCE_TYPE
                }
            },
            "Attributes" : {},
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {
                    "authorise" : "",
                    "authorize" : ""
                }
            }
        }
    ]

[/#macro]

[#macro azure_function_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local functionId = formatResourceId(AZURE_WEB_APP_RESOURCE_TYPE, core.Id)]

    [#local segmentSeedId = formatSegmentSeedId() ]
    [#local segmentSeed = getExistingReference(segmentSeedId)]

    [#local functionName = formatName(core.FullName, segmentSeed)]

    [#assign componentState =
        {
            "Resources" : {
                "function" : {
                    "Id" : functionId,
                    "Name" : functionName,
                    "Type" : AZURE_WEB_APP_RESOURCE_TYPE
                }
            },
            "Attributes" : {
                "URL": functionName + ".azurewebsites.net"
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]

[/#macro]
