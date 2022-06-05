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
                        "dbbase_postgres" : {
                            "Type": "db",
                            "deployment:Unit": "azure-db",
                            "Profiles" : {
                                "Testing" : [ "dbbase_postgres" ]
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
                        },
                        "dbbase_mysql" : {
                            "Type": "db",
                            "deployment:Unit": "azure-db",
                            "Profiles" : {
                                "Testing" : [ "dbbase_mysql" ]
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
            },
            "TestCases" : {
                "dbbase_postgres" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "DatabaseID" : {
                                    "Path" : "outputs.postgresserverXdbXdbbaseXpostgresXurl.value",
                                    "Value" : "[reference(resourceId('Microsoft.DBforPostgreSQL/servers', 'postgresserver-db-dbbase_postgres-568132487'), '2017-12-01', 'Full').properties.fullyQualifiedDomainName]"
                                }
                            }
                        }
                    }
                },
                "dbbase_mysql" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "DatabaseID" : {
                                    "Path" : "outputs.mysqlserverXdbXdbbaseXmysqlXurl.value",
                                    "Value" : "[reference(resourceId('Microsoft.DBforMySQL/servers', 'mysqlserver-db-dbbase_mysql-568132487'), '2017-12-01', 'Full').properties.fullyQualifiedDomainName]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "dbbase_postgres" : {
                    "db" : {
                        "TestCases" : [ "dbbase_postgres" ]
                    }
                },
                "dbbase_mysql" : {
                    "db" : {
                        "TestCases" : [ "dbbase_mysql" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
