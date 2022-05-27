[#ftl]

[#function azGetGlobalConfiguration definition integrations context]

    [#-- Get OpenAPI Specification Version --]
    [#local definitionVersion = (definition.openapi!definition.swagger)!"" ]
    [#local majorVersion = (definitionVersion?split(".")[0])?number ]

    [#-- Determine security schemes explicitly in the definition --]
    [#-- This permits the config to augment/override the definition if required --]
    [#if majorVersion gte 3 ]
        [#local schemes = (definition.Components.SecuritySchemes)!{} ]
    [#else]
        [#local schemes = (definition.securityDefinitions)!{} ]
    [/#if]

    [#-- Add Security Schemes from Context Links --]
    [#-- Userpools --]
    [#list context.AADAppRegistrations!{} as name,value]
        [#local schemes +=
            {
                name : {
                    "Type": "apiKey",
                    "Header": value.Header,
                    "AuthType" : "oauth2",
                    "Authorizer" : {
                        "Type" : "microsoft",
                        "References" : [value.Reference],
                        "Default": true
                    }
                }
            }
        ]
    [/#list]

    [#-- Lambdas --]
    [#list context.LambdaAuthorizers!{} as name,value]
        [#local schemes +=
            {
                name : {
                    "Type": "oauth2",
                    "Header" : "Authorization",
                    "AuthType" : "oauth2",
                    "Authorizer" : {
                        "Type": "microsoft",
                        "Variable" : value.StageVariable
                    }
                }
            }
        ]
    [/#list]

    [#local result =
        getCompositeObject(
            globalChildren + methodChildren,
            globalDefaults,
            methodDefaults,
            {
                "SecuritySchemes" : schemes
            },
            integrations
        )
    ]

    [#-- Correct typing error with Proxy --]
    [#if result.Proxy?? && result.Proxy?is_string]
        [#local result += {"Proxy" : (result.Proxy?lower_case == "true")}]
    [/#if]

    [#return
        result +
        {
            "OpenAPI" : {
                "Version" : definitionVersion,
                "MajorVersion" : majorVersion,
                "Information" : {
                    "Description" : (definition.info.description)!"",
                    "Version" : definition.info.version
                }
            }
        }
    ]

[/#function]

[#function azExtendOpenapiDefinition definition integrations context={} merge=false]

    [#if ! ((definition.openapi!definition.swagger)!"")?has_content ]
        [@fatal
            message="No Swagger/OpenAPI version found"
            detail="A version must be specified at the root using the openapi or swagger key"
            context={
                "APIDefinition": definition
            }
        /]
        [#return definition ]
    [/#if]

    [#-- Determine the global configuration --]
    [#local globalConfiguration =
        azGetGlobalConfiguration(definition, integrations, context)]

    [#-- Start with global content --]
    [#local globalContent =
        mergeObjects(
            valueIfTrue(definition, merge),
            getDeploymentDetails(context, globalConfiguration)
        )
    ]

    [#-- Add the global security --]
    [#local globalContent +=
        getSecurity(globalConfiguration, definition, integrations)]

    [#return globalContent]
[/#function]
