[#ftl]

[#assign skuChildAttributes = [
    {
        "Names" : "Name",
        "Types" : STRING_TYPE
    },
    {
        "Names" : "Tier",
        "Types" : STRING_TYPE
    },
    {
        "Names" : "Capacity",
        "Types" : NUMBER_TYPE
    },
    {
        "Names" : "Size",
        "Types" : [ NUMBER_TYPE, STRING_TYPE ]
    },
    {
        "Names" : "Family",
        "Types" : STRING_TYPE
    }
]]

[@addReference
    type=SKU_PROFILE_REFERENCE_TYPE
    pluralType="SkuProfiles"
    properties=[
            {
                "Type"  : "Description",
                "Value" : "Compute SKU model and hardware type."
            }
        ]
    attributes=[
        {
            "Names" : "apigateway",
            "Children" : [
                {
                    "Names" : "Name",
                    "Types" : STRING_TYPE,
                    "Values" : [ "Developer", "Standard", "Premium", "Basic", "Consumption" ]
                },
                {
                    "Names" : "Capacity",
                    "Types" : NUMBER_TYPE
                }
            ]
        },
        {
            "Names" : "computecluster",
            "Children" : [
                {
                    "Names" : "Name",
                    "Types" : STRING_TYPE
                },
                {
                    "Names" : "Tier",
                    "Types" : STRING_TYPE,
                    "Values" : [ "Standard", "Basic" ]
                },
                {
                    "Names" : "Capacity",
                    "Types" : NUMBER_TYPE,
                    "Default" : 1
                }
            ]
        },
        {
            "Names" : "containerhost",
            "Children" : skuChildAttributes
        },
        {
            "Names" : "s3",
            "Children" : [
                {
                    "Names" : "Kind",
                    "Types" : STRING_TYPE
                },
                {
                    "Names" : "Tier",
                    "Types" : STRING_TYPE
                },
                {
                    "Names" : "Replication",
                    "Types" : STRING_TYPE
                }

            ]
        },
        {
            "Names" : "db",
            "Children" : skuChildAttributes
        },
        {
            "Names" : "secretstore",
            "Children" : [
                {
                    "Names" : "Name",
                    "Types" : STRING_TYPE
                },
                {
                    "Names" : "Family",
                    "Types" : STRING_TYPE
                }
            ]
        },
        {
            "Names" : "network",
            "Children" : [
                {
                    "Names" : "Name",
                    "Types" : STRING_TYPE
                }
            ]
        },
        {
            "Names" : "lb",
            "Children" : [
                {
                    "Names" : "Name",
                    "Types" : STRING_TYPE
                },
                {
                    "Names" : "Tier",
                    "Types" : STRING_TYPE
                },
                {
                    "Names" : "Capacity",
                    "Types" : NUMBER_TYPE
                }
            ]
        },
        {
            "Names" : "bastion",
            "Children" : [
                {
                    "Names" : "Name",
                    "Types" : STRING_TYPE
                },
                {
                    "Names" : "Tier",
                    "Types" : STRING_TYPE
                },
                {
                    "Names" : "Capacity",
                    "Types" : NUMBER_TYPE
                }
            ]
        }
    ]
/]
