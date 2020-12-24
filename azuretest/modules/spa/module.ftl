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
                "Namespace" : "mockedup-integration-application-az-spa-base",
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
                        "spa" : {
                            "spa" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "application-az-spa-base" ]
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
                "basespatemplate" : {
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
                "Component" : {
                    "spa" : {
                        "TestCases" : [ "basespatemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
