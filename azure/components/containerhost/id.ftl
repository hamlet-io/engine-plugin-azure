[#ftl]

[@addResourceGroupInformation
    type=CONTAINERHOST_COMPONENT_TYPE
    provider=AZURE_PROVIDER
    attributes=[
        {
            "Names" : "ScalingProfiles",
            "SubObjects" : true,
            "Children" : azureScalingProfilesChildren
        }
    ]
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_WEB_SERVICE,
            AZURE_INSIGHTS_SERVICE
        ]
/]