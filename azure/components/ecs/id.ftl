[#ftl]

[@addResourceGroupInformation
    type=ECS_COMPONENT_TYPE
    provider=AZURE_PROVIDER
    attributes=[
        {
            "Names" : "OrchestratorVersion",
            "Type" : STRING_TYPE
        }
    ]
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_WEB_SERVICE
        ]
/]