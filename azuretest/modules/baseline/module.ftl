[#ftl]

[@addModule
    name="baseline"
    description="Testing module for the azure baseline component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_baseline ]

    [@loadModule
        blueprint={
            "Tiers" : {
                "mgmt" : {
                    "Components" : {
                        "baseline" : {
                            "Type": "baseline",
                            "deployment:Unit": "baseline",
                            "Profiles" : {
                                "Testing" : [ "baseline" ]
                            },
                            "azure:AdministratorGroups" : [ "1234567890-1234567890-1234567890-1234567890" ]
                        }
                    }
                }
            },
            "TestCases" : {
                "baseline" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "BaselineStorageID" : {
                                    "Path" : "outputs.storageXmgmtXbaseline.value",
                                    "Value" : "[resourceId('Microsoft.Storage/storageAccounts', 'mgmtbaseline568132487568')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "baseline" : {
                    "baseline" : {
                        "TestCases" : [ "baseline" ]
                    }
                }
            }
        }
    /]

[/#macro]
