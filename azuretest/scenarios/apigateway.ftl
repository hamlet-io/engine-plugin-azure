[#ftl]

[#macro azuretest_scenario_apigateway]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "api" : {
                    "Components" : {
                        "apigateway" : {
                            "apigateway" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "azure-apigateway-base" ]
                                    }
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