[#ftl]

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
                    "Type" : STRING_TYPE,
                    "Values" : [ "Developer", "Standard", "Premium", "Basic", "Consumption" ]
                },
                {
                    "Names" : "Capacity",
                    "Type" : NUMBER_TYPE
                }
            ]
        },
        {
            "Names" : [ "storage", "s3", "baselinedata" ],
            "Children" : [
                {
                    "Names" : "Kind",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Tier",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Replication",
                    "Type" : STRING_TYPE
                }

            ]
        },
        {
            "Names" : "db",
            "Children" : [
                {
                    "Names" : "Name",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Tier",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Capacity",
                    "Type" : NUMBER_TYPE
                },
                {
                    "Names" : "Size",
                    "Type" : NUMBER_TYPE
                },
                {
                    "Names" : "Family",
                    "Type" : STRING_TYPE
                }
            ]
        },
        {
            "Names" : "secretstore",
            "Children" : [
                {
                    "Names" : "Name",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Family",
                    "Type" : STRING_TYPE
                }
            ]
        },
        {
            "Names" : "network",
            "Children" : [
                {
                    "Names" : "Name",
                    "Type" : STRING_TYPE
                }
            ]
        },
        {
            "Names" : "lb",
            "Children" : [
                {
                    "Names" : "Name",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Tier",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Capacity",
                    "Type" : NUMBER_TYPE
                }
            ]
        },
        {
            "Names" : "bastion",
            "Children" : [
                {
                    "Names" : "Profiles",
                    "Children" :
                        [
                            {
                                "Names" : "Processor",
                                "Type" : STRING_TYPE
                            }
                        ]
                }
            ]
        },
        {
            "Names" : "spa",
            "Children" : [
                {
                    "Names" : "Name",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Tier",
                    "Type" : STRING_TYPE
                },
                {
                    "Names" : "Capacity",
                    "Children" : [
                        {
                            "Names" : "Count",
                            "Type" : NUMBER_TYPE
                        },
                        {
                            "Names" : "Minimum",
                            "Type" : NUMBER_TYPE
                        },
                        {
                            "Names" : "Maximum",
                            "Type" : NUMBER_TYPE
                        },
                        {
                            "Names" : "ScaleType",
                            "Type" : STRING_TYPE
                        }
                    ]
                },
                {
                    "Names" : "Size",
                    "Type" : NUMBER_TYPE
                },
                {
                    "Names" : "Family",
                    "Type" : STRING_TYPE
                }
            ]
        }
    ]
/]
