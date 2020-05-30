[#ftl]

[@addResourceGroupInformation
    type=COMPUTECLUSTER_COMPONENT_TYPE
    attributes=[
        {
            "Names" : "ScalingProfiles",
            "SubObjects" : true,
            "Children" : [
                {
                    "Names" : "MinCapacity",
                    "Description" : "The minimum capacity of the scaling profile",
                    "Type" : NUMBER_TYPE,
                    "Default" : 1
                },
                {
                    "Names" : "MaxCapacity",
                    "Description" : "The maximum capacity of the scaling profile",
                    "Type" : NUMBER_TYPE,
                    "Default" : 2
                },
                {
                    "Names" : "DefaultCapacity",
                    "Description" : "The default capacity of the scaling profile",
                    "Type" : NUMBER_TYPE,
                    "Default" : 1
                },
                {
                    "Names" : "ScalingRules",
                    "SubObjects" : true,
                    "Children" : [
                        {
                            "Names" : "MetricName",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "TimeGrain",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "Statistic",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "TimeWindow",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "TimeAggregation",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "Operator",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "Threshold",
                            "Type" : NUMBER_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "Direction",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "ActionType",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "Cooldown",
                            "Type" : STRING_TYPE,
                            "Mandatory" : true
                        },
                        {
                            "Names" : "ActionValue",
                            "Type" : NUMBER_TYPE,
                            "Mandatory" : false
                        }
                    ]
                }
            ]
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