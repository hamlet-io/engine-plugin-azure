[#ftl]

[@addModule
    name="gateway"
    description="Testing module for the azure gateway component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]


[#macro azuretest_module_gateway ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "mgmt" : {
                    "Components" : {
                        "gateway" : {
                            "gateway" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "azure-gateway-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "Engine" : "vpcendpoint"
                            }
                        }
                    }
                }
            },
            "TestCases" : {},
            "TestProfiles" : {}
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
