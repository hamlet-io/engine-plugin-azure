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
                                    "Testing" : [ "Component" ]
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
                                    "Value" : AZURE_RESOURCE_ID_MOCK_VALUE
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
