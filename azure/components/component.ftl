[#ftl]

[#assign secretChildrenConfiguration =
    [
        {
            "Names" : "Name",
            "Type" : STRING_TYPE
        },
        {
            "Names" : "Setting",
            "Description" : "The desired setting label/key for this Secret's value i.e DB_CONNECTION_STRING.",
            "Type" : STRING_TYPE
        }
    ]
]

[#assign secretSettingsConfiguration = 
    [
        {
            "Names" : "Prefix",
            "Description" : "Settings with this prefix and ending in _SECRET will be considered a Secret.",
            "Type" : STRING_TYPE
        }
    ]
]

[#assign azureScalingProfilesChildren = [
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
]]