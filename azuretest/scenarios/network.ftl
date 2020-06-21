[#ftl]

[#macro azuretest_scenario_network]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "mgmt" : {
                    "Components" : {
                        "vnet" : {
                            "network" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "vpc" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "RouteTables": {
                                    "internal": {},
                                    "external": {
                                        "Public": true
                                    }
                                },
                                "NetworkACLs": {
                                    "open": {
                                        "Rules": {
                                            "in": {
                                                "Priority": 200,
                                                "Action": "allow",
                                                "Source": {
                                                    "IPAddressGroups": [
                                                        "_global"
                                                    ]
                                                },
                                                "Destination": {
                                                    "IPAddressGroups": [
                                                        "_localnet"
                                                    ],
                                                    "Port": "any"
                                                },
                                                "ReturnTraffic": false
                                            },
                                            "out": {
                                                "Priority": 200,
                                                "Action": "allow",
                                                "Source": {
                                                    "IPAddressGroups": [
                                                        "_localnet"
                                                    ]
                                                },
                                                "Destination": {
                                                    "IPAddressGroups": [
                                                        "_global"
                                                    ],
                                                    "Port": "any"
                                                },
                                                "ReturnTraffic": false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "basenetworktemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "VNetID" : {
                                    "Path" : "outputs.vnetXmgmtXvpc.value",
                                    "Value" : "/subscriptions/12345678-abcd-efgh-ijkl-123456789012/resourceGroups/mockRG/providers/Microsoft.Mock/mockR/mock-resource-name"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "network" : {
                        "TestCases" : [ "basenetworktemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]