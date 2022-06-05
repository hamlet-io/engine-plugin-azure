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
            "apiXapigatewaybase" : {
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
        settingSets=[
            {
                "Type" : "Settings",
                "Scope" : "Products",
                "Namespace" : "mockedup-integration-api-apigatewaybase",
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
                        "apigatewaybase" : {
                            "Type": "apigateway",
                            "deployment:Unit": "azure-apigateway",
                            "Profiles" : {
                                "Testing" : [ "apigatewaybase" ]
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
            },
            "TestCases" : {
                "apigatewaybase" : {
                    "OutputSuffix" : "template.json",
                    "Structural" : {
                        "JSON" : {
                            "Match" : {
                                "APIMID" : {
                                    "Path" : "outputs.serviceXmockedupXintegrationXapiXapigatewaybase.value",
                                    "Value" : "[resourceId('Microsoft.ApiManagement/service', 'mockedup-integration-api-apigatewaybase-568132487')]"
                                }
                            }
                        }
                    }
                }
            },
            "TestProfiles" : {
                "apigatewaybase" : {
                    "apigateway" : {
                        "TestCases" : [ "apigatewaybase" ]
                    }
                }
            }
        }
    /]

[/#macro]
