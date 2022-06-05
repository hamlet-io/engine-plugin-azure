[#ftl]

[@addModule
    name="adaptor"
    description="Testing module for the azure adaptor component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_adaptor ]

    [@loadModule
        settingSets=[
            {
                "Type" : "Builds",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-mgmt-adaptorbase",
                "Settings" : {
                    "COMMIT" : AZURE_BUILD_COMMIT_MOCK_VALUE,
                    "FORMATS" : ["lambda"]
                }
            }
        ]
        blueprint={
            "Tiers" : {
                "mgmt" : {
                    "Components" : {
                        "adaptorbase" : {
                            "Type": "adaptor",
                            "deployment:Unit": "azure-adaptor",
                            "Profiles" : {
                                "Testing" : "adaptorbase"
                            },
                            "Extensions" : [ "_azure_adaptorbase" ]
                        }
                    }
                }
            },
            "TestCases" : {
                "adaptorbase": {
                    "OutputSuffix" : "config.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "Name" : {
                                    "Path" : "NAME",
                                    "Value" : "mockedup-integration-management-adaptorbase"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "adaptorbase": {
                    "adaptor": {
                        "TestCases": [ "adaptorbase"]
                    }
                }
            }
        }
    /]

[/#macro]
