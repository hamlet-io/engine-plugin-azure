[#ftl]

[#macro azuretest_scenario_spa]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "spa" : {
                            "spa" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "application-az-spa-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "basespatemplate" : {
                    "OutputSuffix" : "config.json",
                    "Structural" : {
                        "JSON" : {
                            "Exists" :  [
                                "RUN_ID"
                            ]
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "spa" : {
                        "TestCases" : [ "basespatemplate" ]
                    }
                }
            }            
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]