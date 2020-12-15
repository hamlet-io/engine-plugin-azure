[#ftl]

[@addModule
    name="adaptor"
    description="Testing module for the azure adaptor component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_adaptor ]

    [@loadModule
        settingSets=[
            {
                "Type" : "Builds",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-azure-adaptor-base",
                "Settings" : {
                    "COMMIT" : "123456789#MockCommit#",
                    "FORMATS" : ["lambda"]
                }
            }
        ]
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
                                "Fragment" : "MockFragment"
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
