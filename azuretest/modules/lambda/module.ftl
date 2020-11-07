[#ftl]

[@addModule
    name="lambda"
    description="Testing module for the azure lambda component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]


[#macro azuretest_module_lambda ]

    [@loadModule
        settingSets=[]
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
                                        "Fragment" : "_mockfrag",
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
                                    "Path" : "",
                                    "Value" : "/subscriptions/12345678-abcd-efgh-ijkl-123456789012/resourceGroups/mockRG/providers/Microsoft.Mock/mockR/mock-resource-name"
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
