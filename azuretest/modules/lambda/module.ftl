[#ftl]

[@addModule
    name="lambda"
    description="Testing module for the azure lambda component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]


[#macro azuretest_module_lambda ]

    [@loadModule
        settingSets=[
            {
                "Type" : "Builds",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-application-az-lambda-base",
                "Settings" : {
                    "COMMIT" : AZURE_BUILD_COMMIT_MOCK_VALUE,
                    "FORMATS" : ["lambda"]
                }
            }
        ]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "lambda" : {
                            "lambda" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "application-az-lambda-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "Functions" : {
                                    "api" : {
                                        "Handler" : "src/handler.api",
                                        "RunTime" : "nodejs",
                                        "Extensions" : [ "_mockext" ],
                                        "Links" : {}
                                    }
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "baselambdatemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "AppServicePlanID" : {
                                    "Path" : "outputs.sitesXappXlambdaXapi.value",
                                    "Value" : AZURE_RESOURCE_ID_MOCK_VALUE
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "lambda" : {
                        "TestCases" : [ "baselambdatemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
