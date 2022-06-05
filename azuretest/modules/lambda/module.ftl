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
                "Namespace" : "mockedup-integration-app-lambda",
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
                        "lambdabase" : {
                            "Type" : "lambda",
                            "deployment:Unit" : "azure-lambda",
                            "Profiles" : {
                                "Testing" : [ "lambdabase" ]
                            },
                            "Functions" : {
                                "api" : {
                                    "Handler" : "src/handler.api",
                                    "RunTime" : "nodejs14.x"
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "lambdabase" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "AppServicePlanID" : {
                                    "Path" : "outputs.sitesXappXlambdabaseXapi.value",
                                    "Value" : "[resourceId('Microsoft.Web/sites', 'mockedup-int-app-lambdabase-api-568132487')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "lambdabase" : {
                    "function" : {
                        "TestCases" : [ "lambdabase" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
