[#ftl]

[@addResourceGroupInformation
    type=LB_COMPONENT_TYPE
    attributes=[]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_NETWORK_APPLICATION_GATEWAY_SERVICE,
            AZURE_NETWORK_SERVICE
        ]
/]

[@addResourceGroupInformation
    type=LB_PORT_COMPONENT_TYPE
    attributes=[]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_NETWORK_APPLICATION_GATEWAY_SERVICE
        ]
/]