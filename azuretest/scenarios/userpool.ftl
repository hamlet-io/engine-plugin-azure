[#ftl]

[#macro azuretest_scenario_userpool]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "dir" : {
                    "Components" : {
                        "userpool" : {
                            "userpool" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "solution-az-userpool-base" ]
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
                "baseuserpooltemplate" : {
                    "OutputSuffix" : "prologue.sh",
                    "Structural" : {
                        "Bash" : {
                            "NotEmpty" :  [
                                "."
                            ]
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "userpool" : {
                        "TestCases" : [ "baseuserpooltemplate" ]
                    }
                }
            }            
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]