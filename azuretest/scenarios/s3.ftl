[#ftl]

[#macro azuretest_scenario_s3]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "stage" : {
                            "s3" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "azure-s3-base" ]
                                    }
                                },
                                "Lifecycle" : {
                                    "Versioning" : true
                                },
                                "PublicAccess" : {
                                    "default" : {
                                        "IPAddressGroups" : [ "_localnet" ]
                                    }
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "bases3template" : {
                    "OutputSuffix" : "template.json"
                }
            }            
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]