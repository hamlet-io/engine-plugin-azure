[#ftl]

[@addResourceGroupInformation
    type=COMPUTECLUSTER_COMPONENT_TYPE
    attributes=[
        {
            "Names" : "ScalingProfiles",
            "SubObjects" : true,
            "Children" : autoScaleProfileChildrenConfiguration
        }
    ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_VIRTUALMACHINE_SERVICE,
            AZURE_INSIGHTS_SERVICE,
            AZURE_NETWORK_SERVICE,
            AZURE_AUTHORIZATION_SERVICE
        ]
/]