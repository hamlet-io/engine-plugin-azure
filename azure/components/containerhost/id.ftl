[#ftl]

[@addResourceGroupInformation
    type=CONTAINERHOST_COMPONENT_TYPE
    provider=AZURE_PROVIDER
    attributes=[
        {
            "Names" : "Profiles",
            "Children" : [
                {
                    "Names" : "Sku",
                    "Types" : STRING_TYPE,
                    "Default" : "default"
                },
                {
                    "Names" : "VMImage",
                    "Types" : STRING_TYPE,
                    "Default" : "default"
                },
                {
                    "Names" : "Scaling",
                    "SubObjects" : true,
                    "Children" : azureScalingProfilesChildren
                }
            ] 
        }
    ]
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_WEB_SERVICE,
            AZURE_INSIGHTS_SERVICE
        ]
/]