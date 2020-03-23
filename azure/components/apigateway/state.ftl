[#ftl]

[#macro azure_apigateway_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#-- Process Resource Naming Conditions --]
    [#local serviceId = formatResourceId(AZURE_API_MANAGEMENT_SERVICE, core.FullName)]
    [#local serviceName = formatAzureResourceName(
        "apimService",
        AZURE_API_MANAGEMENT_SERVICE
    )]
    [#local authorizationserverId = formatResourceId(AZURE_API_MANAGEMENT_SERVICE_AUTHORIZATION_SERVER, core.FullName)]
    [#local authorizationserverName = formatAzureResourceName(
        formatName(AZURE_API_MANAGEMENT_SERVICE_AUTHORIZATION_SERVER, core.ShortName),
        AZURE_API_MANAGEMENT_SERVICE_AUTHORIZATION_SERVER,
        serviceName
    )]
    [#local identityproviderId = formatResourceId(AZURE_API_MANAGEMENT_SERVICE_IDENTITY_PROVIDER, core.FullName)]
    [#local identityproviderName = formatAzureResourceName(
        formatName(AZURE_API_MANAGEMENT_SERVICE_IDENTITY_PROVIDER, core.ShortName),
        AZURE_API_MANAGEMENT_SERVICE_IDENTITY_PROVIDER,
        serviceName
    )]

    [#local productId = formatResourceId(AZURE_API_MANAGEMENT_SERVICE_PRODUCT, core.ShortName)]
    [#local productName = formatAzureResourceName(
        formatName(AZURE_API_MANAGEMENT_SERVICE_PRODUCT, core.ShortName),
        AZURE_API_MANAGEMENT_SERVICE_PRODUCT,
        serviceName
    )]

    [#local apiId = formatResourceId(AZURE_API_MANAGEMENT_SERVICE_API, core.ShortName)]
    [#local apiName = formatAzureResourceName(
        formatName(AZURE_API_MANAGEMENT_SERVICE_API, core.ShortName),
        AZURE_API_MANAGEMENT_SERVICE_API,
        serviceName
    )]
 
    [#local schemaId = formatDependentResourceId(AZURE_API_MANAGEMENT_SERVICE_API_SCHEMA, core.ShortName)]
    [#local schemaName = formatAzureResourceName(
        AZURE_API_MANAGEMENT_SERVICE_API_SCHEMA,
        AZURE_API_MANAGEMENT_SERVICE_API_SCHEMA,
        apiName
    )]

    [#assign componentState =
        {
            "Resources" : {
                "service" : {
                    "Id": serviceId,
                    "Name" : serviceName,
                    "Type" : AZURE_API_MANAGEMENT_SERVICE,
                    "Reference" : getReference(serviceId, serviceName)
                },
                "authorizationserver" : {
                    "Id": authorizationserverId,
                    "Name" : authorizationserverName,
                    "Type" : AZURE_API_MANAGEMENT_SERVICE_AUTHORIZATION_SERVER,
                    "Reference" : getReference(authorizationserverId, authorizationserverName)
                },
                "identityprovider" : {
                    "Id": identityproviderId,
                    "Name" : identityproviderName,
                    "Type" : AZURE_API_MANAGEMENT_SERVICE_IDENTITY_PROVIDER,
                    "Reference" : getReference(identityproviderId, identityproviderName)
                },
                "product" : {
                    "Id": productId,
                    "Name" : productName,
                    "Type" : AZURE_API_MANAGEMENT_SERVICE_PRODUCT,
                    "Reference" : getReference(productId, productName)
                },
                "api" : {
                    "Id" : apiId,
                    "Name" : apiName,
                    "Type" : AZURE_API_MANAGEMENT_SERVICE_API,
                    "Reference" : getReference(apiId, apiName)
                },
                "schema" : {
                    "Id" : schemaId,
                    "Name" : schemaName,
                    "Type" : AZURE_API_MANAGEMENT_SERVICE_API_SCHEMA,
                    "Reference" : getReference(schemaId, schemaName)
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