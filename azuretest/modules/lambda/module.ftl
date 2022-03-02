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
                "Namespace" : "mockedup-integration-app-lambda-api",
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
                            "Type" : "lambda",
                            "deployment:Unit" : "application-az-lambda-base",
                            "Profiles" : {
                                "Testing" : [ "baselambdatemplate" ]
                            },
                            "Functions" : {
                                "api" : {
                                    "Handler" : "src/handler.api",
                                    "RunTime" : "nodejs14.x",
                                    "Extensions" : [ "_mockext" ],
                                    "Links" : {}
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
                "baselambdatemplate" : {
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
