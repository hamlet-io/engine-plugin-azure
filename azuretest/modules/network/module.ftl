[#ftl]

[@addModule
    name="network"
    description="Testing module for the azure network component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_network ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "mgmt" : {
                    "Components" : {
                        "networkbase" : {
                            "Type": "network",
                            "deployment:Unit": "azure-network",
                            "Profiles" : {
                                "Testing" : [ "networkbase" ]
                            },
                            "RouteTables": {
                                "internal": {},
                                "external": {
                                    "Public": true
                                }
                            },
                            "Logging" : {
                                "FlowLogs" : {
                                    "default" : {
                                        "Action" : "accept",
                                        "Enabled" : true
                                    }
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
            },
            "TestCases" : {
                "networkbase" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "VNetID" : {
                                    "Path" : "outputs.vnetXmgmtXnetworkbase.value",
                                    "Value" : "[resourceId('Microsoft.Network/virtualNetworks', 'mockedup-int-mgmt-networkbase-network')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "networkbase" : {
                    "network" : {
                        "TestCases" : [ "networkbase" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
