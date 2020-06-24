[#ftl]

[#macro azuretest_scenario_db]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "db" : {
                    "Components" : {
                        "database" : {
                            "db" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "solution-az-db-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "DatabaseName" : "mockdb",
                                "Engine" : "postgres",
                                "EngineVersion" : "11",
                                "Port" : "postgresql",
                                "GenerateCredentials" : {
                                    "Enabled" : true,
                                    "MasterUserName" : "mockuser",
                                    "CharacterLength" : 20
                                },
                                "Size" : 20,
                                "azure:SecretSettings": {
                                    "Prefix": "MOCK"
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "basedbtemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "DatabaseID" : {
                                    "Path" : "outputs.postgresdbXdbXdatabase.value",
                                    "Value" : "/subscriptions/12345678-abcd-efgh-ijkl-123456789012/resourceGroups/mockRG/providers/Microsoft.Mock/mockR/mock-resource-name"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "db" : {
                        "TestCases" : [ "basedbtemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]