[#ftl]

[#macro azuretest_scenario_s3]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "stage" : {
                            "S3" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "azure-s3-base" ]
                                    }
                                },
                                "Lifecycle" : {
                                    "Versioning" : true
                                },
                                "PublicAccess" : {
                                    "default" : {
                                        "IPAddressGroups" : [ "_localnet" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "bases3template" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "StorageID" : {
                                    "Path" : "outputs.storageXappXstage.value",
                                    "Value" : "/subscriptions/12345678-abcd-efgh-ijkl-123456789012/resourceGroups/mockRG/providers/Microsoft.Mock/mockR/mock-resource-name"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "s3" : {
                        "TestCases" : [ "bases3template" ]
                    }
                }
            }            
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]