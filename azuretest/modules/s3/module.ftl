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
                        "s3base" : {
                            "Type": "s3",
                            "deployment:Unit": "azure-s3",
                            "Lifecycle" : {
                                "Versioning" : true
                            },
                            "PublicAccess" : {
                                "default" : {
                                    "IPAddressGroups" : [ "_localnet" ]
                                }
                            },
                            "Profiles" : {
                                "Testing" : [ "s3base" ]
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "s3base" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "StorageID" : {
                                    "Path" : "outputs.storageXappXs3base.value",
                                    "Value" : "[resourceId('Microsoft.Storage/storageAccounts', 'apps3base568132487')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "s3base" : {
                    "s3" : {
                        "TestCases" : [ "s3base" ]
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
