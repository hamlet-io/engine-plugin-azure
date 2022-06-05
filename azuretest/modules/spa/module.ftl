[#ftl]

[@addModule
    name="spa"
    description="Testing module for the azure spa component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_spa ]

    [@loadModule
        settingSets=[
            {
                "Type" : "Builds",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-app-spabase",
                "Settings" : {
                    "COMMIT" : AZURE_BUILD_COMMIT_MOCK_VALUE,
                    "FORMATS" : ["spa"]
                }
            }
        ]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "spabase" : {
                            "Type": "spa",
                            "deployment:Unit": "azure-spa",
                            "Profiles" : {
                                "Testing" : [ "spabase" ]
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "spabase" : {
                    "OutputSuffix" : "config.json",
                    "Structural" : {
                        "JSON" : {
                            "Exists" :  [
                                "RUN_ID"
                            ]
                        }
                    }
                }
            },
            "TestProfiles" : {
                "spabase" : {
                    "spa" : {
                        "TestCases" : [ "spabase" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
