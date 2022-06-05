[#ftl]

[@addModule
    name="gateway"
    description="Testing module for the azure gateway component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]


[#macro azuretest_module_gateway ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "GatewaySubnet" : {
                    "Network": {
                        "Enabled": true,
                        "Link": {
                            "Tier": "GatewaySubnet",
                            "Component": "gatewaybase_private_network"
                        },
                        "NetworkACL" : "_none",
                        "RouteTable" : "default"
                    },
                    "Components" : {
                        "gatewaybase_private" : {
                            "Type": "gateway",
                            "deployment:Unit": "azure-gateway",
                            "Profiles" :{
                                "Testing": ["gatewaybase_private"]
                            },
                            "Engine" : "private",
                            "Destinations": {
                                "dst": {

                                }
                            }
                        },
                        "gatewaybase_private_network": {
                            "Type": "network",
                            "deployment:Unit": "azure-gateway",
                            "RouteTables" : {
                                "default": {}
                            },
                            "NetworkACLs": {
                                "_none": {}
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "gatewaybase_private": {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "gatewayVnet" : {
                                    "Path" : "outputs.vnetXGatewaySubnetXgatewaybaseXprivateXnetwork.value",
                                    "Value" : "[resourceId('Microsoft.Network/virtualNetworks', 'mockedup-int-GatewaySubnet-gatewaybase_private_network-network')]"
                                },
                                "networkGateway": {
                                    "Path": "outputs.virtualNetworkGWXGatewaySubnetXgatewaybaseXprivateXgateway.value",
                                    "Value": "[resourceId('Microsoft.Network/virtualNetworkGateways', 'virtualNetworkGW-GatewaySubnet-gatewaybase_private-gateway')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "gatewaybase_private": {
                    "gateway": {
                        "TestCases": ["gatewaybase_private"]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
