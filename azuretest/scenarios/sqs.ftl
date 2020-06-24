[#ftl]

[#macro azuretest_scenario_sqs]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "sqs" : {
                            "sqs" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "solution-az-sqs-base" ]
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
                "basesqstemplate" : {
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
                    "sqs" : {
                        "TestCases" : [ "basesqstemplate" ]
                    }
                }
            }            
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]