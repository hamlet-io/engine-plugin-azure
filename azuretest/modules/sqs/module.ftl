[#ftl]

[@addModule
    name="sqs"
    description="Testing module for the azure sqs component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_sqs ]

    [#--TODO(roleyfoley): add tests for bash script --]
    [@loadModule
        settingSets=[]
        blueprint={
            "Tiers" : {
                "app" : {
                    "Components" : {
                        "sqsbase" : {
                            "Type": "sqs",
                            "deployment:Unit": "azure-sqs"
                        }
                    }
                }
            }
        }
        stackOutputs=[]
        commandLineOption={}
    /]

[/#macro]
