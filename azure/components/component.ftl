[#ftl]

[#assign secretChildrenConfiguration =
    [
        {
            "Names" : "Name",
            "Types" : STRING_TYPE
        },
        {
            "Names" : "Setting",
            "Description" : "The desired setting label/key for this Secret's value i.e DB_CONNECTION_STRING.",
            "Types" : STRING_TYPE
        }
    ]
]

[#assign secretSettingsConfiguration = 
    [
        {
            "Names" : "Prefix",
            "Description" : "Settings with this prefix and ending in _SECRET will be considered a Secret.",
            "Types" : STRING_TYPE
        }
    ]
]

[#assign azureScalingProfilesChildren = [
    {
        "Names" : "MinCapacity",
        "Description" : "The minimum capacity of the scaling profile",
        "Types" : NUMBER_TYPE,
        "Default" : 1
    },
    {
        "Names" : "MaxCapacity",
        "Description" : "The maximum capacity of the scaling profile",
        "Types" : NUMBER_TYPE,
        "Default" : 2
    },
    {
        "Names" : "DefaultCapacity",
        "Description" : "The default capacity of the scaling profile",
        "Types" : NUMBER_TYPE,
        "Default" : 1
    },
    {
        "Names" : "ScalingRules",
        "SubObjects" : true,
        "Children" : [
            {
                "Names" : "MetricName",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "TimeGrain",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "Statistic",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "TimeWindow",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "TimeAggregation",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "Operator",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "Threshold",
                "Types" : NUMBER_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "Direction",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "ActionType",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "Cooldown",
                "Types" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "ActionValue",
                "Types" : NUMBER_TYPE,
                "Mandatory" : false
            }
        ]
    }
]]