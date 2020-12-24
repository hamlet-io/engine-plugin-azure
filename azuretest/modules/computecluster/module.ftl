[#ftl]

[@addModule
    name="computecluster"
    description="Testing module for the azure computecluster component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_computecluster ]

    [@loadModule
        settingSets=[
            {
                "Type" : "Builds",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-application-az-computecluster-base",
                "Settings" : {
                    "COMMIT" : AZURE_BUILD_COMMIT_MOCK_VALUE
                }
            },
            {
                "Type" : "Settings",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-application-az-computecluster-base",
                "Settings" : {
                    "Master" : {
                        "Username" : "bojangles"
                    }
                }
            }
        ]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "computecluster" : {
                            "computecluster" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "application-az-computecluster-base" ]
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
                                                "MetricName" : "CpuPercentage",
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
                                                "MetricName" : "CpuPercentage",
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
                                    "Path" : "outputs.vmssXsettingsXappXcomputecluster.value",
                                    "Value" : AZURE_RESOURCE_ID_MOCK_VALUE
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
