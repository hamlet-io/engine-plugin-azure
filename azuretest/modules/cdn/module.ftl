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
                        "cdnbase" : {
                            "Type": "cdn",
                            "deployment:Unit": "azure-cdn",
                            "Profiles" : {
                                "Testing" : [ "cdnbase" ]
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
            },
            "TestCases" : {
                "cdnbase" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "FrontDoorID" : {
                                    "Path" : "outputs.frontdoorXwebXcdnbase.value",
                                    "Value" : "[resourceId('Microsoft.Network/frontDoors', 'mockedup-integration-web-cdnbase-568132487')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "cdnbase" : {
                    "cdn" : {
                        "TestCases" : [ "cdnbase" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
