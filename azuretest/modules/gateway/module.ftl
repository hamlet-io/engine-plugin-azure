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
            "TestCases" : {
                "basegatewaytemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "ID" : {
                                    "Path" : "",
                                    "Value" : "/subscriptions/12345678-abcd-efgh-ijkl-123456789012/resourceGroups/mockRG/providers/Microsoft.Mock/mockR/mock-resource-name"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "gateway" : {
                        "TestCases" : [ "basegatewaytemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
