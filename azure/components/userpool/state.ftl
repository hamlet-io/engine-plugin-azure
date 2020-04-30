[#ftl]

[#macro azure_userpool_arm_state occurrence parent={}]
    
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#assign componentState = 
        {
            "Resources" : {},
            "Attributes" : {
                "API_AUTHORIZATION_HEADER" : solution.AuthorizationHeader
            },
            "Roles" : {}
        }
    ]

[/#macro]

[#macro azure_userpoolclient_arm_state occurrence parent={}]
    
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local id = formatResourceId(AZURE_APPLICATION_REGISTRATION_RESOURCE_TYPE, core.Name)]
    [#local name = formatName(core.Name)]

    [#local clientAppId = formatId(id, "appid")]

    [#local parentAttributes = parent.State.Attributes]

    [#assign componentState=
        {
            "Resources" : {
                "client" : {
                    "Id" : id,
                    "ClientAppId" : clientAppId,
                    "Name" : name,
                    "Type" : AZURE_APPLICATION_REGISTRATION_RESOURCE_TYPE,
                    "Reference" : getReference(id, name)
                }
            },
            "Attributes" : parentAttributes + {
                "CLIENT_APP_ID" : getExistingReference(clientAppId),
                "CLIENT_OBJECT_ID" : getExistingReference(id)
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]

[/#macro]

[#macro azure_userpoolauthprovider_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local name = solution.azure\:Engine]

    [#assign componentState = 
        {
            "Resources" : {},
            "Attributes" : {
                "PROVIDER_NAME": name
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]

[/#macro]

[#macro azure_userpoolresource_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#assign componentState =
        {
            "Resources" : {},
            "Attributes" : {},
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]
[/#macro]