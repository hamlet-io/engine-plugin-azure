[#ftl]

[@addResourceGroupInformation
    type=LAMBDA_COMPONENT_TYPE
    attributes=[]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_STORAGE_SERVICE,
            AZURE_WEB_SERVICE,
            AZURE_AUTHORIZATION_SERVICE
        ]
/]

[@addResourceGroupInformation
    type=LAMBDA_FUNCTION_COMPONENT_TYPE
    attributes=[]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_STORAGE_SERVICE,
            AZURE_WEB_SERVICE,
            AZURE_AUTHORIZATION_SERVICE
        ]
/]
