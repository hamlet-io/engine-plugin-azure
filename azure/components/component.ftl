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