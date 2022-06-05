[#ftl]

[@addModule
    name="userpool"
    description="Testing module for the azure userpool component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_userpool ]

    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "dir" : {
                    "Components" : {
                        "userpoolbase" : {
                            "Type": "userpool",
                            "deployment:Unit": "azure-userpool"
                        }
                    }
                }
            },
            "TestCases" : {},
            "TestProfiles" : {}
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
