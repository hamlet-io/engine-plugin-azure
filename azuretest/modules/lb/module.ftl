[#ftl]

[@addModule
    name="lb"
    description="Testing module for the azure lb component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_lb ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "elb" : {
                    "Components" : {
                        "lbbase" : {
                            "Type": "lb",
                            "deployment:Unit": "azure-lb",
                            "Profiles" : {
                                "Testing" : [ "lbbase" ]
                            },
                            "Engine" : "application",
                            "Ports" : {
                                "testport" : {}
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "lbbase" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "AppGatewayID" : {
                                    "Path" : "outputs.appGatewayXmockedupXintegrationXelbXlbbase.value",
                                    "Value" : "[resourceId('Microsoft.Network/applicationGateways', 'appGateway-mockedup-integration-elb-lbbase')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "lbbase" : {
                    "lb" : {
                        "TestCases" : [ "lbbase" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
