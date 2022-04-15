[#ftl]

[@registerInputSeeder
    id=AZURETEST_INPUT_SEEDER
    description="Azure test provider inputs"
/]

[@addSeederToConfigPipeline
    stage=FIXTURE_SHARED_INPUT_STAGE
    seeder=AZURETEST_INPUT_SEEDER
/]

[#function azuretest_configseeder_fixture filter state]

    [#-- Don't check the provider to avoid chicken and egg situation --]
    [#return
        addToConfigPipelineClass(
            state,
            BLUEPRINT_CONFIG_INPUT_CLASS,
            {
                "Account": {
                    "Provider" : AZURE_PROVIDER
                },
                "Product" : {
                    "Modules" : {
                        "adaptor" : {
                            "Provider" : "azuretest",
                            "Name" : "adaptor"
                        },
                        "apigateway" : {
                            "Provider" : "azuretest",
                            "Name" : "apigateway"
                        },
                        "baseline" : {
                            "Provider" : "azuretest",
                            "Name" : "baseline"
                        },
                        "bastion" : {
                            "Provider" : "azuretest",
                            "Name" : "bastion"
                        },
                        "cdn" : {
                            "Provider" : "azuretest",
                            "Name" : "cdn"
                        },
                        "computecluster" : {
                            "Provider" : "azuretest",
                            "Name" : "computecluster"
                        },
                        "db" : {
                            "Provider" : "azuretest",
                            "Name" : "db"
                        },
                        "gateway" : {
                            "Provider" : "azuretest",
                            "Name" : "gateway"
                        },
                        "lambda" : {
                            "Provider" : "azuretest",
                            "Name" : "lambda"
                        },
                        "lb" : {
                            "Provider" : "azuretest",
                            "Name" : "lb"
                        },
                        "network" : {
                            "Provider" : "azuretest",
                            "Name" : "network"
                        },
                        "s3" : {
                            "Provider" : "azuretest",
                            "Name" : "s3"
                        },
                        "spa" : {
                            "Provider" : "azuretest",
                            "Name" : "spa"
                        },
                        "sqs" : {
                            "Provider" : "azuretest",
                            "Name" : "sqs"
                        },
                        "userpool" : {
                            "Provider" : "azuretest",
                            "Name" : "userpool"
                        }
                    }
                }
            },
            FIXTURE_SHARED_INPUT_STAGE
        )
    ]

[/#function]
