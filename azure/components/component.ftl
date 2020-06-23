[#ftl]

[#-- AutoScale --]
[#assign autoScaleProfileChildrenConfiguration = 
    [
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
            "Names" : "Rules",
            "Description" : "The auto scaling rules for the associated profile.",
            "Mandatory" : false,
            "Subobjects" : true,
            "Children" : [
                {
                    "Names" : "MetricName",
                    "Description" : "The name of the metric that defines what the rule monitors.",
                    "Type" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "TimeGrain",
                    "Description" : "The granularity of metrics the rule monitors.",
                    "Type" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "Statistic",
                    "Description" : "The statistic defining how the metrics from multiple instances are combined.",
                    "Type" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "TimeWindow",
                    "Description" : "The range of time in which instance data is collected.",
                    "Type" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "TimeAggregation",
                    "Description" : "How the data that is collected should be combined over time.",
                    "Type" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "Operator",
                    "Description" : "Comparison operator, in language string format - i.e LessThanOrEqual.",
                    "Type" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "Threshold",
                    "Description" : "The threshold of the metric that triggers the scale action.",
                    "Type" : NUMBER_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "Direction",
                    "Description" : "The scaling direction.",
                    "Type" : STRING_TYPE,
                    "Values" : ["None", "Increase", "Decrease"],
                    "Mandatory" : true
                },
                {
                    "Names" : "ActionType",
                    "Description" : "The type of action that should occur when the scale rule fires.",
                    "Type" : STRING_TYPE,
                    "Values" : ["ChangeCount", "PercentChangeCount", "ExactCount"],
                    "Mandatory" : true
                },
                {
                    "Names" : "Cooldown",
                    "Description" : "The amount of time to wait since the last scaling action before this action occurs. It must be between 1 week and 1 minute in ISO 8601 format.",
                    "Type" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "ActionValue",
                    "Description" : "The number of instances that are involved in the scaling action. Must be 1 or greater.",
                    "Type" : NUMBER_TYPE,
                    "Mandatory" : false
                }
            ]
        },
        {
            "Names" : "Schedule",
            "Mandatory" : false,
            "Children" : [
                {
                    "Names" : "Enabled",
                    "Type" : BOOLEAN_TYPE,
                    "Default" : false
                },
                {
                    "Names" : "Frequency",
                    "Description" : "How often the schedule profile should take effect.",
                    "Type" : STRING_TYPE,
                    "Values" : ["None", "Second", "Minute", "Hour", "Day", "Week", "Month", "Year"],
                    "Mandatory" : true
                },
                {
                    "Names" : "TimeZone",
                    "Description" : "The TimeZone for the hours of the profile.",
                    "Type" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "Days",
                    "Description" : "The collection of days that the profile takes effect on.",
                    "Type" : ARRAY_OF_STRING_TYPE,
                    "Values" : [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ],
                    "Mandatory" : true
                },
                {
                    "Names" : "Hours",
                    "Description" : "A collection of hours that the profile takes effect on. Valid values are 0 - 23 as per a 24-hour clock.",
                    "Type" : ARRAY_OF_NUMBER_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "Minutes",
                    "Description" : "A collection of minutes (0 - 59) that a profile takes effect on.",
                    "Type" : ARRAY_OF_NUMBER_TYPE,
                    "Mandatory" : true
                }
            ]
        }
    ]
]

[#-- Secrets --]
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