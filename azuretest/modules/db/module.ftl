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
                                    "Testing" : [ "postgrestest" ]
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
                        },
                        "mysqldb" : {
                            "db" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "solution-az-mysqldb" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "mysqltest" ]
                                },
                                "DatabaseName" : "mockdb",
                                "Engine" : "mysql",
                                "EngineVersion" : "5.7",
                                "Port" : "mysql",
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
                },
                "mysqldbtemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "DatabaseID" : {
                                    "Path" : "outputs.mysqlserverXdbXmysqldbXurl.value",
                                    "Value" : "https://mock.local/mysqlserverXdbXmysqldbXurl"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "postgrestest" : {
                    "db" : {
                        "TestCases" : [ "basedbtemplate" ]
                    }
                },
                "mysqltest" : {
                    "db" : {
                        "TestCases" : [ "mysqldbtemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
