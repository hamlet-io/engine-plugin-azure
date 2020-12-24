[#ftl]

[@addModule
    name="bastion"
    description="Testing module for the azure bastion component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]


[#macro azuretest_module_bastion ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "mgmt" : {
                    "Components" : {
                        "bastion" : {
                            "bastion" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "segment-az-bastion-base" ]
                                    }
                                },
                                "Enabled" : true,
                                "MultiAZ": false,
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "basebastiontemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "ScaleSetID" : {
                                    "Path" : "outputs.vmssXmanagementXbastionXbastion.value",
                                    "Value" : AZURE_RESOURCE_ID_MOCK_VALUE
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "bastion" : {
                        "TestCases" : [ "basebastiontemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
