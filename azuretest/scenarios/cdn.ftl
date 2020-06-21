[#ftl]

[#macro azuretest_scenario_cdn]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "web" : {
                    "Components" : {
                        "testingcdn" : {
                            "cdn" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "azure-cdn-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "Certificate": {
                                    "Host" : "mawk"
                                },
                                "WAF": {
                                    "OWASP" : true
                                },
                                "Profiles" : {
                                    "Security" : "high"
                                },
                                "Routes" : {
                                    "default" : {
                                        "PathPattern" : "_default",
                                        "Origin" : {
                                            "Link" : {
                                                "Tier" : "web",
                                                "Component" : "testingsparoute"
                                            }
                                        },
                                        "Compress" : true
                                    }
                                }
                            }
                        },
                        "testingsparoute" : {
                            "spa" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "testingsparoute" ]
                                    }
                                },
                                "ConfigPath" : "config",
                                "Links" : {
                                    "userpoolclient" : {
                                        "Tier" : "dir",
                                        "Component" : "mockuserpool",
                                        "Client": "portal"
                                    }
                                }
                            }
                        },
                        "mockuserpool" : {
                            "userpool" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "mockuserpool"]
                                    }
                                },
                                "Clients" : {
                                    "portal" : {
                                        "ClientGenerateSecret" : true,
                                        "OAuth" : {
                                            "Flows" : [
                                                "implicit"
                                            ]
                                        },
                                        "AuthProviders": [
                                            "aad"
                                        ],
                                        "azure:AllowOtherTenants": true
                                    }
                                },
                                "AuthProviders" : {
                                    "aad" : {
                                        "Engine" : "OIDC",
                                        "azure:Engine": "aad"
                                    }
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "basecdntemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "FrontDoorID" : {
                                    "Path" : "outputs.frontdoorXwebXtestingcdn.value",
                                    "Value" : "/subscriptions/12345678-abcd-efgh-ijkl-123456789012/resourceGroups/mockRG/providers/Microsoft.Mock/mockR/mock-resource-name"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "cdn" : {
                        "TestCases" : [ "basecdntemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]