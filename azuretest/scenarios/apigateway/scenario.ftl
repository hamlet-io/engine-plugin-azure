[#ftl]

[@addScenario
    name="apigateway"
    description="Testing scenario for the azure apigateway component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_scenario_apigateway ]

    [@loadScenario
        settingSets=[
            {
                "Type" : "Builds",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-application-az-apigateway-base",
                "Settings" : {
                    "COMMIT" : "123456789#MockCommit#",
                    "FORMATS" : ["mockformat"]
                }
            },
            {
                "Type" : "Settings",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-application-az-apigateway-base",
                "Settings" : {
                    "apigw": {
                        "Internal": true,
                        "Value": {
                            "Type": "lambda",
                            "Proxy": false,
                            "BinaryTypes": ["*/*"],
                            "ContentHandling": "CONVERT_TO_TEXT",
                            "Variable": "LAMBDA_API_LAMBDA"
                        }
                    }
                }
            }
        ]
        blueprint={
            "Tiers" : {
                "api" : {
                    "Components" : {
                        "apigateway" : {
                            "apigateway" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "application-az-apigateway-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "Certificate": {
                                    "Enabled" : false
                                },
                                "Links" : {},
                                "BasePathBehaviour" : "ignore",
                                "azure:Contact": {
                                    "Name" : "Mock Ock",
                                    "Email": "m.ock@example.com"
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "baseapigatewaytemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "APIMID" : {
                                    "Path" : "outputs.apiManagementServiceXmockedupXintegrationXapiXapigateway.value",
                                    "Value" : "/subscriptions/12345678-abcd-efgh-ijkl-123456789012/resourceGroups/mockRG/providers/Microsoft.Mock/mockR/mock-resource-name"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "apigateway" : {
                        "TestCases" : [ "baseapigatewaytemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
