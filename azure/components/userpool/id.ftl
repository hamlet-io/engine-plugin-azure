[#ftl]

[#-- Azure does not have a concept of userpool's as         --]
[#-- other providers (AWS) have. In order to perform any    --]
[#-- action in Azure you must already have an Azure Active  --]
[#-- Directory (AAD) account. Thus userpools themselves     --]
[#-- do not perform any configuration, however the child    --]
[#-- components - Auth Provider and Client - do have Azure  --]
[#-- equivalents and so do generate content.                --]

[@addResourceGroupInformation
    type=USERPOOL_COMPONENT_TYPE
    attributes=[]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=[
        AZURE_AAD_APP_REGISTRATION_PSEUDO_SERVICE
    ]
/]

[@addResourceGroupInformation
    type=USERPOOL_AUTHPROVIDER_COMPONENT_TYPE
    attributes=[
        {
            "Names" : "Engine",
            "Description" : "The authentication/identity provider type. Values are specific to API Management Identity Provider resource..",
            "Types" : STRING_TYPE,
            "Values" : [
                "facebook", 
                "google", 
                "microsoft", 
                "twitter", 
                "aad", 
                "aadb2c"
            ],
            "Mandatory" : true
        }
    ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=[
        AZURE_AAD_APP_REGISTRATION_PSEUDO_SERVICE
    ]
/]

[@addResourceGroupInformation
    type=USERPOOL_CLIENT_COMPONENT_TYPE
    attributes=[
        {
            "Names" : "AllowOtherTenants",
            "Description" : "Application can be used by other Azure AD Tenants.",
            "Types" : BOOLEAN_TYPE,
            "Default" : false
        },
        {
            "Names" : "ReplyUrls",
            "Description" : "URI's to which Azure AD will redirect in response to an OAuth 2.0 Request",
            "Types": ARRAY_OF_STRING_TYPE
        }
    ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=[
        AZURE_AAD_APP_REGISTRATION_PSEUDO_SERVICE
    ]
/]

[@addResourceGroupInformation
    type=USERPOOL_RESOURCE_COMPONENT_TYPE
    attributes=[]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=[
        AZURE_AAD_APP_REGISTRATION_PSEUDO_SERVICE
    ]
/]