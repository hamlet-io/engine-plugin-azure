[#ftl]

[@addModule
    name="cdn"
    description="Testing module for the azure cdn component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_cdn ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "web" : {
                    "Components" : {
                        "cdn" : {
                            "cdn" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "solution-az-cdn-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ],
                                    "Security" : "high"
                                },
                                "Certificate": {
                                    "Host" : "mawk"
                                },
                                "WAF": {
                                    "OWASP" : true
                                },
                                "Routes" : {}
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
                                    "Path" : "outputs.frontdoorXwebXcdn.value",
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
