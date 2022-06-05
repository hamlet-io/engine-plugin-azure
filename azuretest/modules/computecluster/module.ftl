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
                "Namespace" : "mockedup-integration-app-computeclusterbase",
                "Settings" : {
                    "COMMIT" : AZURE_BUILD_COMMIT_MOCK_VALUE
                }
            },
            {
                "Type" : "Settings",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-app-computeclusterbase",
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
                        "computeclusterbase" : {
                            "Type": "computecluster",
                            "deployment:Unit": "azure-computecluster",
                            "Profiles" : {
                                "Testing" : [ "computeclusterbase" ]
                            },
                            "Ports" : {
                                "http" : {
                                    "IPAddressGroups" : ["_global"]
                                },
                                "https" : {
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
            },
            "TestCases" : {
                "computeclusterbase" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "ScaleSetID" : {
                                    "Path" : "outputs.vmssXsettingsXappXcomputeclusterbase.value",
                                    "Value" : "[resourceId('Microsoft.Compute/virtualMachineScaleSets', 'app-computeclusterbase')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "computeclusterbase" : {
                    "computecluster" : {
                        "TestCases" : [ "computeclusterbase" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
