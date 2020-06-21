[#ftl]

[#macro azuretest_scenario_computecluster]

    [@addScenario
        settingSets=[]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "computecluster" : {
                            "computecluster" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "azure-computecluster-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "Ports" : {
                                    "http" : {
                                        "IPAddressGroups" : ["_global"]
                                    },
                                    "https" : {
                                        "Port" : "https",
                                        "IPAddressGroups" : ["_global"]
                                    }
                                },
                                "DockerHost" : true,
                                "azure:ScalingProfiles" : {
                                    "default" : {
                                        "MinCapacity" : 1,
                                        "MaxCapacity" : 2,
                                        "DefaultCapacity" : 1,
                                        "ScalingRules" : {
                                            "workerUp" : {
                                                "MetricName" : "Percentage CPU",
                                                "TimeGrain" : "PT1M",
                                                "Statistic" : "Average",
                                                "TimeWindow" : "PT5M",
                                                "TimeAggregation" : "Average",
                                                "Operator" : "GreaterThan",
                                                "Threshold" : 50,
                                                "Direction" : "Increase",
                                                "ActionType" : "ChangeCount",
                                                "Cooldown" : "PT5M",
                                                "ActionValue" : 1
                                            },
                                            "workerDown" : {
                                                "MetricName" : "Percentage CPU",
                                                "TimeGrain" : "PT1M",
                                                "Statistic" : "Average",
                                                "TimeWindow" : "PT5M",
                                                "TimeAggregation" : "Average",
                                                "Operator" : "LessThan",
                                                "Threshold" : 30,
                                                "Direction" : "Decrease",
                                                "ActionType" : "ChangeCount",
                                                "Cooldown" : "PT5M",
                                                "ActionValue" : 1
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
                "basecomputeclustertemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "ScaleSetID" : {
                                    "Path" : "",
                                    "Value" : "/subscriptions/12345678-abcd-efgh-ijkl-123456789012/resourceGroups/mockRG/providers/Microsoft.Mock/mockR/mock-resource-name"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "computecluster" : {
                        "TestCases" : [ "basecomputeclustertemplate" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]