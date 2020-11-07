[#ftl]

[@addModule
    name="sqs"
    description="Testing module for the azure sqs component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_sqs ]

    [@loadModule
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
