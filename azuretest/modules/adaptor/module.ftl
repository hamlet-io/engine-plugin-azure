[#ftl]

[@addModule
    name="adaptor"
    description="Testing module for the azure adaptor component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_adaptor ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "mgmt" : {
                    "Components" : {
                        "adaptortest" : {
                            "adaptor" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "azure-adaptor-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "Extensions" : [ "MockFragment" ]
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "baseadaptortemplate" : {
                    "OutputSuffix" : "prologue.sh",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "LinkedId" : {
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
                    "adaptor" : {
                        "TestCases" : [ "baseadaptortemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
