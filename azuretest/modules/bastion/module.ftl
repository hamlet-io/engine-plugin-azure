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
                        "bastionbase" : {
                            "Type": "bastion",
                            "deployment:Unit": "azure-bastion",
                            "Active" : true,
                            "MultiAZ": false,
                            "Profiles" : {
                                "Testing" : [ "bastionbase" ]
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "bastionbase" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "ScaleSetID" : {
                                    "Path" : "outputs.vmssXmanagementXbastionbaseXbastion.value",
                                    "Value" : "[resourceId('Microsoft.Compute/virtualMachineScaleSets', 'vmss-management-bastionbase-bastion')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "bastionbase" : {
                    "bastion" : {
                        "TestCases" : [ "bastionbase" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
