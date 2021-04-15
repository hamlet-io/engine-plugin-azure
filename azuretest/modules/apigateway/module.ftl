[#ftl]

[@addModule
    name="apigateway"
    description="Testing module for the azure apigateway component"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_apigateway ]

    [@loadModule
        definitions={
            "appXapigateway" : {
                "openapi": "3.0.0",
                "info": {
                    "version": "1.0.0",
                    "title": "Sample API",
                    "description": "A sample API to illustrate OpenAPI concepts"
                },
                "paths": {
                    "/list": {
                        "get": {
                            "description": "Returns a list of stuff",
                            "responses": {
                                "200": {
                                    "description": "Successful response"
                                }
                            }
                        }
                    }
                }
            }
        }
    /]

    [@loadModule
        settingSets=[
            {
                "Type" : "Builds",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-application-az-apigateway-base",
                "Settings" : {
                    "COMMIT" : AZURE_BUILD_COMMIT_MOCK_VALUE,
                    "FORMATS" : ["openapi"]
                }
            },
            {
                "Type" : "Settings",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-application-az-apigateway-base",
                "Settings" : {
                    "apigw": {
                        "Internal": true,
                        "Value": {
                            "Type": "lambda",
                            "Proxy": false,
                            "BinaryTypes": ["*/*"],
                            "ContentHandling": "CONVERT_TO_TEXT",
                            "Variable": "LAMBDA_API_LAMBDA"
                        }
                    }
                }
            }
        ]
        blueprint={
            "Tiers" : {
                "api" : {
                    "Components" : {
                        "apigateway" : {
                            "apigateway" : {
                                "Instances" : {
                                    "default" : {
                                        "DeploymentUnits" : [ "application-az-apigateway-base" ]
                                    }
                                },
                                "Profiles" : {
                                    "Testing" : [ "Component" ]
                                },
                                "Image" : {
                                    "Source" : "none"
                                },
                                "Certificate": {
                                    "Enabled" : false
                                },
                                "Links" : {},
                                "BasePathBehaviour" : "ignore",
                                "azure:Contact": {
                                    "Name" : "Mock Ock",
                                    "Email": "m.ock@example.com"
                                }
                            }
                        }
                    }
                }
            },
            "TestCases" : {
                "baseapigatewaytemplate" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "APIMID" : {
                                    "Path" : "outputs.serviceXmockedupXintegrationXapiXapigateway.value",
                                    "Value" : AZURE_RESOURCE_ID_MOCK_VALUE
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "Component" : {
                    "apigateway" : {
                        "TestCases" : [ "baseapigatewaytemplate" ]
                    }
                }
            }
        }
    /]

[/#macro]
