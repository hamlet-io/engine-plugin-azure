[#ftl]

[@addScenario
    name="s3"
    description="Testing scenario for the azure s3 component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_scenario_s3 ]

    [@loadScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "stage" : {
                            "S3" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "solution-az-s3-base" ]
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
