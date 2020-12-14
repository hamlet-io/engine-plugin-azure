[#ftl]

[#assign apiManagementResourceprofiles =
    {
        AZURE_API_MANAGEMENT_SERVICE : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service",
            "conditions" : [ "name_to_lower", "globally_unique", "alphanumerichyphens_only", "max_length" ],
            "max_name_length" : 50,
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                }
            }
        },
        AZURE_API_MANAGEMENT_SERVICE_API : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/apis",
            "outputMappings" : {}
        },
        AZURE_API_MANAGEMENT_SERVICE_API_OPERATION : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/apis/operations",
            "outputMappings" : {}
        },
        AZURE_API_MANAGEMENT_SERVICE_API_SCHEMA : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/apis/schemas",
            "outputMappings" : {}
        },
        AZURE_API_MANAGEMENT_SERVICE_AUTHORIZATION_SERVER : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/authorizationServers",
            "outputMappings" : {}
        },
        AZURE_API_MANAGEMENT_SERVICE_BACKEND : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/backends",
            "outputMappings" : {}
        },
        AZURE_API_MANAGEMENT_SERVICE_IDENTITY_PROVIDER : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/identityProviders",
            "outputMappings" : {}
        },
        AZURE_API_MANAGEMENT_SERVICE_PRODUCT : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/products",
            "outputMappings" : {}
        },
        AZURE_API_MANAGEMENT_SERVICE_PRODUCT_API : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/products/apis",
            "outputMappings" : {}
        },
        AZURE_API_MANAGEMENT_SERVICE_PRODUCT_GROUP : {
            "apiVersion" : "2019-01-01",
            "type" : "Microsoft.ApiManagement/service/products/groups",
            "outputMappings" : {}
        }
    }
]

[#list apiManagementResourceprofiles as resourceType,resourceProfile]
  [@addResourceProfile
    service=AZURE_NETWORK_SERVICE
    resource=resourceType
    profile=resourceProfile
  /]
[/#list]

[#function getApiManagementServiceCertificate
    storeName
    encodedCertificate=""
    certificatePwd=""
    certificateExpiry=""
    certificateThumbprint=""
    certificateSubject=""]

    [#return
        {
            "storeName" : storeName
        } +
        attributeIfContent("encodedCertificate", encodedCertificate) +
        attributeIfContent("certificatePassword", certificatePwd) +
        attributeIfContent("certificate",
            attributeIfContent("expiry", certificateExpiry) +
            attributeIfContent("thumbprint", certificateThumbprint) +
            attributeIfContent("subject", certificateSubject)
        )
    ]

[/#function]

[#function getApiManagementServiceAdditionalLocation
    location
    skuName
    skuCapacity=""
    vnetSubnetId=""]

    [#return
        {
            "location": location,
            "sku" : {
                "name" : skuName
            } +
            attributeIfContent("capacity", skuCapacity)
        } +
        attributeIfContent("virtualNetworkConfiguration",
            attributeIfContent("subnetResourceId", vnetSubnetId)
        )
    ]
[/#function]

[#function getApiManagementServiceHostnameConfiguration
    type
    hostname
    keyVaultId=""
    encodedCertificate=""
    certificatePwd=""
    defaultSslBinding=false
    negotiateClientCertificate=false
    certificateExpiry=""
    certificateThumbprint=""
    certificateSubject=""]

    [#return
        {
            "type" : type,
            "hostName" : hostname
        } +
        attributeIfContent("keyVaultId", keyVaultId) +
        attributeIfContent("encodedCertificate", encodedCertificate) +
        attributeIfContent("certificatePassword", certificatePwd) +
        attributeIfTrue("defaultSslBinding", defaultSslBinding, defaultSslBinding) +
        attributeIfTrue("negotiateClientCertificate", negotiateClientCertificate, negotiateClientCertificate) +
        attributeIfContent("certificate",
            attributeIfContent("expiry", certificateExpiry) +
            attributeIfContent("thumbprint", certificateThumbprint) +
            attributeIfContent("subject", certificateSubject)
        )
    ]

[/#function]

[#macro createApiManagementService
    id
    name
    location
    skuName
    publisherEmail
    publisherName
    notificationSenderEmail=""
    hostnameConfigurations=[]
    virtualNetworkConfigurationSubnetId=""
    additionalLocations=[]
    customProperties={}
    certificates=[]
    enableClientCertificate=false
    vnetType="Internal"
    skuCapacity=""
    identity={}
    resources=[]
    dependsOn=[]]

    [#--- Setting is for Consumption SKU Only --]
    [#if ! (skuName == "Consumption")]
        [#local enableClientCertificate = false]
    [/#if]

    [#local sku =
        {
            "name" : skuName
        } +
        numberAttributeIfContent("capacity", skuCapacity)
    ]

    [#local properties =
        {
            "publisherEmail" : publisherEmail,
            "publisherName" : publisherName
        } +
        attributeIfContent("notificationSenderEmail", notificationSenderEmail) +
        attributeIfContent("hostnameConfigurations", hostnameConfigurations) +
        attributeIfContent("virtualNetworkConfiguration",
            attributeIfContent("subnetResourceId", virtualNetworkConfigurationSubnetId)
        ) +
        attributeIfContent("additionalLocations", additionalLocations) +
        attributeIfContent("customProperties", customProperties) +
        attributeIfContent("certificates", certificates) +
        attributeIfTrue("enableClientCertificate", enableClientCertificate, enableClientCertificate) +
        attributeIfContent("virtualNetworkType", vnetType)
    ]

    [@armResource
        id=id
        name=name
        sku=sku
        location=location
        profile=AZURE_API_MANAGEMENT_SERVICE
        identity=identity
        properties=properties
        resources=resources
        dependsOn=dependsOn
    /]

[/#macro]

[#macro createApiManagementServiceApi
    id
    name
    path
    description=""
    type=""
    apiRevision=""
    apiRevisionDescription=""
    apiVersion=""
    apiVersionDescription=""
    oAuth2AuthServerId=""
    oAuth2Scope=""
    openIdProviderId=""
    openIdBearerTokenSendingMethods=""
    isCurrent=false
    apiVersionSetId=""
    apiVersionSetName=""
    apiVersionSetDescription=""
    apiVersionSetVersioningScheme=""
    apiVersionSetVersionQueryName=""
    apiVersionSetVersionHeaderName=""
    subscriptionRequired=false
    sourceApiId=""
    displayName=""
    serviceUrl=""
    protocols=[]
    value=""
    format="openapi"
    wsdlServiceName=""
    wsdlEndpointName=""
    apiType=""
    resources=[]
    dependsOn=[]]

    [#local properties = {
            "path" : path
        } +
        attributeIfContent("description", description) +
        attributeIfContent("authenticationSettings",
            attributeIfContent("oAuth2",
                attributeIfContent("authorizationServerId", oAuth2AuthServerId) +
                attributeIfContent("scope", oAuth2Scope)
            ) +
            attributeIfContent("openid",
                attributeIfContent("openidProviderId", openIdProviderId) +
                attributeIfContent("bearerTokenSendingMethods", openIdBearerTokenSendingMethods)
            )
        ) +
        attributeIfContent("type", type) +
        attributeIfContent("apiRevision", apiRevision) +
        attributeIfContent("apiVersion", apiVersion) +
        attributeIfTrue("isCurrent", isCurrent, isCurrent) +
        attributeIfContent("apiRevisionDescription", apiRevisionDescription) +
        attributeIfContent("apiVersionDescription", apiVersionDescription) +
        attributeIfContent("apiVersionSetId", apiVersionSetId) +
        attributeIfContent("apiVersionSet",
            attributeIfContent("name", apiVersionSetName) +
            attributeIfContent("description", apiVersionSetDescription) +
            attributeIfContent("versioningScheme", apiVersionSetVersioningScheme) +
            attributeIfContent("versionQueryName", apiVersionSetVersionQueryName) +
            attributeIfContent("versionHeaderName", apiVersionSetVersionHeaderName)
        ) +
        attributeIfTrue("subscriptionRequired", subscriptionRequired, subscriptionRequired) +
        attributeIfContent("sourceApiId", sourceApiId) +
        attributeIfContent("displayName", displayName) +
        attributeIfContent("serviceUrl", serviceUrl) +
        attributeIfContent("protocols", protocols) +
        attributeIfContent("value", value) +
        attributeIfContent("format", format) +
        attributeIfContent("wsdlSelector",
            attributeIfContent("wsdlServiceName", wsdlServiceName) +
            attributeIfContent("wsdlEndpointName", wsdlEndpointName)
        ) +
        attributeIfContent("apiType", apiType)
    ]

    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_API
        properties=properties
        resources=resources
        dependsOn=dependsOn
    /]

[/#macro]

[#function getApiManagementServiceTokenBodyParameter name value]
    [#return {"name": name, "value": value}]
[/#function]

[#macro createApiManagementServiceAuthorizationServer
    id
    name
    clientRegistrationEndpoint
    authorizationEndpoint
    grantTypes
    clientId
    displayName=name
    description=""
    authorizationMethods=["GET"]
    clientAuthenticationMethod=["Basic"]
    tokenBodyParameters=[]
    tokenEndpoint=""
    supportState=false
    defaultScope=""
    bearerTokenSendingMethods=[]
    clientSecret=""
    resourceOwnerUsername=""
    resourceOwnerPassword=""
    dependsOn=[]]

    [#local properties =
        {
            "displayName": displayName,
            "clientRegistrationEndpoint": clientRegistrationEndpoint,
            "authorizationEndpoint": authorizationEndpoint,
            "grantTypes": grantTypes,
            "clientId" : clientId
        } +
        attributeIfContent("description", description) +
        attributeIfContent("authorizationMethods", authorizationMethods) +
        attributeIfContent("clientAuthenticationMethod", clientAuthenticationMethod) +
        attributeIfContent("tokenBodyParameters", tokenBodyParameters) +
        attributeIfContent("tokenEndpoint", tokenEndpoint) +
        attributeIfTrue("supportState", supportState, supportState) +
        attributeIfContent("defaultScope", defaultScope) +
        attributeIfContent("bearerTokenSendingMethods", bearerTokenSendingMethods) +
        attributeIfContent("clientSecret", clientSecret) +
        attributeIfContent("resourceOwnerUsername", resourceOwnerUsername) +
        attributeIfContent("resourceOwnerUsername", resourceOwnerPassword)
    ]

    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_AUTHORIZATION_SERVER
        properties=properties
        dependsOn=dependsOn
    /]
[/#macro]

[#-- This function is used within many parts of the service/apis/operations template: --]
[#-- templateParameters --]
[#-- queryParameters    --]
[#-- headers            --]
[#-- formParameters     --]
[#function getApiManagementServiceApiOperationParameterContract
    name
    type
    description=""
    defaultValue=""
    required=false
    values=[]]

    [#return
        {
            "name" : name,
            "type" : type
        } +
        attributeIfContent("description", description) +
        attributeIfContent("defaultValue", defaultValue) +
        attributeIfTrue("required", required, required) +
        attributeIfContent("values", values)
    ]

[/#function]

[#-- This function is used within many parts of the service/apis/operations template: --]
[#-- request.representations  --]
[#-- response.representations --]
[#function getApiManagementServiceApiOperationRepresentationContract
    contentType
    sample=""
    schemaId=""
    typeName=""
    formParameters=[]]

    [#return
        {
            "contentType" : contentType
        } +
        attributeIfContent("sample", sample) +
        attributeIfContent("schemaId", schemaId) +
        attributeIfContent("typeName", typeName) +
        attributeIfContent("formParameters", formParameters)
    ]
[/#function]

[#function getApiManagementServiceApiOperationResponseContract
    statusCode
    description=""
    representations=[]
    headers=[]]

    [#return
        {
            "statusCode": statusCode
        } +
        attributeIfContent("description", description) +
        attributeIfContent("representations", representations) +
        attributeIfContent("headers", headers)
    ]
[/#function]

[#macro createApiManagementServiceApiOperation
    id
    name
    method
    displayName=name
    templateParameters=[]
    description=""
    requestDescription=""
    requestQueryParameters=[]
    requestHeaders=[]
    requestRepresentations=[]
    responses=[]
    policies=""
    urlTemplate=""
    resources=[]
    dependsOn=[]]

    [#local properties =
        {
            "method" : method,
            "displayName" : displayName
        } +
        attributeIfContent("templateParameters", templateParameters) +
        attributeIfContent("description", description) +
        attributeIfContent("request",
            attributeIfContent("description", requestDescription) +
            attributeIfContent("queryParameters", requestQueryParameters) +
            attributeIfContent("headers", requestHeaders) +
            attributeIfContent("representations", requestRepresentations)
        ) +
        attributeIfContent("responses", responses) +
        attributeIfContent("policies", policies) +
        attributeIfContent("urlTemplate", urlTemplate)
    ]

    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_API_OPERATION
        properties=properties
        resources=resources
        dependsOn=dependsOn
    /]

[/#macro]

[#macro createApiManagementServiceApiSchema
    id
    name
    contentType
    documentValue=""
    resources=[]
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_API_SCHEMA
        dependsOn=dependsOn
        resources=resources
        properties=
            {
                "contentType" : contentType
            } +
            attributeIfContent("document",
                attributeIfContent("value", documentValue)
            )
    /]

[/#macro]

[#macro createApiManagementServiceProduct
    id
    name
    displayName=name
    description=""
    terms=""
    subscriptionRequired=false
    approvalRequired=false
    subscriptionsLimit=""
    state=""
    resources=[]
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_PRODUCT
        resources=resources
        dependsOn=dependsOn
        properties=
            {
                "displayName" : displayName
            } +
            attributeIfContent("description", description) +
            attributeIfContent("terms", terms) +
            attributeIfTrue("subscriptionRequired", subscriptionRequired, subscriptionRequired) +
            attributeIfTrue("approvalRequired", approvalRequired, approvalRequired) +
            attributeIfContent("subscriptionsLimit", subscriptionsLimit) +
            attributeIfContent("state", state)
    /]

[/#macro]

[#-- Resource has a non-standard schema --]
[#macro createApiManagementServiceProductApi
    id
    name]

    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_PRODUCT_API
    /]

[/#macro]

[#-- Resource has a non-standard schema --]
[#macro createApiManagementServiceProductGroup
    id
    name]

    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_PRODUCT_GROUP
    /]

[/#macro]

[#function getApiManagementServiceBackendServiceFabricClusterCertName name="" thumbprint=""]
    [#return {"name": name, "issuerCertificateThumbprint": thumbprint}]
[/#function]

[#macro createApiManagementServiceBackend
    id
    name
    url
    protocol
    title=""
    description=""
    resourceId=""
    tlsValidateCertificateChain=false
    tlsValidateCertificateName=false
    proxyUrl=""
    proxyUsername=""
    proxyPassword=""
    credentialsCertificate=[]
    credentialsQuery={}
    credentialsHeader={}
    credentialsAuthorizationScheme=""
    credentialsAuthorizationParameter=""
    serviceFabricClusterClientCertificateThumbprint=""
    serviceFabricClusterMaxPartitionResolutionRetries=""
    serviceFabricClusterManagementEndpoints=[]
    serviceFabricClusterServerCertificateThumbprints=[]
    serviceFabricClusterServerCertificateNames=[]
    resources=[]
    dependsOn=[]]


    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_BACKEND
        resources=resources
        dependsOn=dependsOn
        properties=
            {
                "url" : url,
                "protocol" : protocol
            } +
            attributeIfContent("title", title) +
            attributeIfContent("description", description) +
            attributeIfContent("resourceId", resourceId) +
            attributeIfContent("tls",
                attributeIfContent("validateCertificateChain", tlsValidateCertificateChain) +
                attributeIfContent("validateCertificateName", validateCertificateName)
            ) +
            attributeIfContent("proxy",
                attributeIfContent("url", proxyUrl) +
                attributeIfContent("username", proxyUsername) +
                attributeIfContent("password", proxyPassword)
            ) +
            attributeIfContent("credentials",
                attributeIfContent("certificate", credentialsCertificate) +
                attributeIfContent("query", credentialsQuery) +
                attributeIfContent("header", credentialsHeader) +
                attributeIfContent("authorization",
                    attributeIfContent("scheme", credentialsAuthorizationScheme) +
                    attributeIfContent("parameter", credentialsAuthorizationParameter)
                )
            ) +
            attributeIfContent("properties",
                attributeIfContent("serviceFabricCluster",
                    attributeIfContent("managementEndpoints", serviceFabricClusterManagementEndpoints) +
                    attributeIfContent("clientCertificatethumbprint", serviceFabricClusterClientCertificateThumbprint) +
                    numberAttributeIfContent("maxPartitionResolutionRetries", serviceFabricClusterMaxPartitionResolutionRetries) +
                    attributeIfContent("serverCertificateThumbprints", serviceFabricClusterServerCertificateThumbprints) +
                    attributeIfContent("serverX509Names", serviceFabricClusterServerCertificateNames)
                )
            )
    /]

[/#macro]

[#macro createApiManagementServiceIdentityProvider
    id
    name
    clientId
    keyvaultId
    keyvaultSecret
    type=""
    signinTenant=""
    allowedTenants=[]
    authority=""
    signupPolicyName=""
    signinPolicyName=""
    profileEditingPolicyName=""
    passwordResetPolicyName=""
    resources=[]
    dependsOn=[]]

    [@createKeyVaultParameterLookup
        secretName=keyvaultSecret
        vaultId=keyvaultId
    /]

    [@armResource
        id=id
        name=name
        profile=AZURE_API_MANAGEMENT_SERVICE_IDENTITY_PROVIDER
        resources=resources
        dependsOn=dependsOn
        properties=
            {
                "clientId": clientId,
                "clientSecret": getParameterReference(keyvaultSecret)
            } +
            attributeIfContent("type", type) +
            attributeIfContent("signinTenant", signinTenant) +
            attributeIfContent("allowedTenants", allowedTenants) +
            attributeIfContent("authority", authority) +
            attributeIfContent("signupPolicyName", signupPolicyName) +
            attributeIfContent("signinPolicyName", signinPolicyName) +
            attributeIfContent("profileEditingPolicyName", profileEditingPolicyName) +
            attributeIfContent("passwordResetPolicyName", passwordResetPolicyName)
    /]

[/#macro]
