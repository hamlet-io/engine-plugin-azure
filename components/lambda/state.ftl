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
                "Outbound" : {}
            }
        }
    ]

[/#macro]

[#macro azure_function_arm_state occurrence parent={}]

    [#local core = occurrence.Core]

    [#assign componentState =
        {
            "Resources" : {
                "function" : {
                    "Id" : formatResourceId(AZURE_WEB_APP_RESOURCE_TYPE, core.Id),
                    "Name" : core.ShortName,
                    "Type" : AZURE_WEB_APP_RESOURCE_TYPE
                }
            },
            "Attributes" : {},
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]

[/#macro]