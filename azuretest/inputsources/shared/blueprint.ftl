[#ftl]

[#-- Intial seeding of settings data based on input data --]
[#macro azuretest_input_shared_blueprint_seed ]
    [@addBlueprint
        blueprint={
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
        }
    /]
[/#macro]
