[#ftl]

[@addModule
    name="s3"
    description="Testing module for the azure s3 component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_s3 ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "stage" : {
                            "S3" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "solution-az-s3-base" ]
                                    }
                                },
                                "Lifecycle" : {
                                    "Versioning" : true
                                },
                                "PublicAccess" : {
                                    "default" : {
                                        "IPAddressGroups" : [ "_localnet" ]
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
                "bases3template" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "StorageID" : {
                                    "Path" : "outputs.storageXappXstage.value",
                                    "Value" : AZURE_RESOURCE_ID_MOCK_VALUE
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "s3" : {
                        "TestCases" : [ "bases3template" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
