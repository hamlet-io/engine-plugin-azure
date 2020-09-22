[#ftl]

[@addModule
    name="db"
    description="Testing module for the azure db component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_db ]

    [@loadModule
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
                                    "Path" : "outputs.postgresserverXdbXdatabaseXurl.value",
                                    "Value" : "https://mock.local/postgresserverXdbXdatabaseXurl"
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
