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
            "Names" : "s3",
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
        }
    ]
/]

[#function getSkuProfile occurrence type extensions... ]	
    [#local tc = formatComponentShortName(	
                    occurrence.Core.Tier,	
                    occurrence.Core.Component,	
                    extensions)]	
    [#local defaultProfile = "default"]	
    [#if (skuProfiles[defaultProfile][tc])??]	
        [#return skuProfiles[defaultProfile][tc]]	
    [/#if]	
    [#if (skuProfiles[defaultProfile][type])??]	
        [#return skuProfiles[defaultProfile][type]]	
    [/#if]	
[/#function]