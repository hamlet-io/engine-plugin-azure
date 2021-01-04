[#ftl]

[@addModule
    name="baseline"
    description="Testing module for the azure baseline component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_baseline ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "mgmt" : {
                    "Components" : {
                        "baseline" : {
                            "baseline" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "segment-az-baseline-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "azure:AdministratorGroups" : [ "1234567890-1234567890-1234567890-1234567890" ]
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "basebaselinetemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "BaselineStorageID" : {
                                    "Path" : "outputs.storageXmgmtXbaseline.value",
                                    "Value" : AZURE_RESOURCE_ID_MOCK_VALUE
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "baseline" : {
                        "TestCases" : [ "basebaselinetemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
