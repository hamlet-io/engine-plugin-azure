[#ftl]

[#-- Seeding a mock JSON OpenApi Spec definition --]
[#macro azure_input_mock_definition_seed]

    [@addDefinition 
        definition=
            {   
                "apiXapigateway" : {
                    "openapi" : "3.0.1",
                    "info" : {
                        "title" : "Hamlet Mock API",
                        "description" : "API for testing hamlet",
                        "version" : "1.0"
                    },
                    "servers" : [ {
                        "url" : "https://mock.com"
                    } ],
                    "security" : [ {
                        "apiKeyHeader" : [ ]
                    }, {
                        "apiKeyQuery" : [ ]
                    } ],
                    "paths" : {
                        "/mockpath" : {
                        "post" : {
                            "summary" : "Mock POST method",
                            "description" : "mock description",
                            "operationId" : "mock-example",
                            "requestBody" : {
                                "content" : {
                                    "application/json" : {
                                        "schema" : {
                                            "$ref" : "#/mock/example/ref"
                                        }
                                    }
                                }
                            },
                            "responses" : {
                                "200" : {
                                    "description" : "OK",
                                    "content" : {
                                        "application/json" : {
                                            "schema" : {
                                                "$ref" : "#/mock/example/ref"
                                            }
                                        }
                                    }
                                },
                                "401" : {
                                    "description" : "Auth Failed",
                                    "content" : {
                                        "application/json" : {
                                            "schema" : {
                                                "$ref" : "#/mock/example/ref"
                                            }
                                        }
                                    }
                                },
                                "500" : {
                                    "description" : "Submission failed",
                                    "content" : {
                                        "application/json" : {
                                            "schema" : {
                                                "$ref" : "#/mock/example/ref"
                                            }
                                        }
                                    }
                                }
                            }
                        },
                        "options" : {
                            "tags" : [ "CORS" ],
                            "summary" : "CORS support",
                            "description" : "Enable CORS by returning correct headers\n",
                            "responses" : {
                            "200" : {
                                "description" : "Default response for CORS method",
                                "headers" : {
                                    "Access-Control-Allow-Origin" : {
                                        "style" : "simple",
                                        "explode" : false,
                                        "schema" : {
                                            "type" : "string"
                                        }
                                    },
                                    "Access-Control-Allow-Methods" : {
                                        "style" : "simple",
                                        "explode" : false,
                                        "schema" : {
                                            "type" : "string"
                                        }
                                    },
                                    "Access-Control-Allow-Headers" : {
                                        "style" : "simple",
                                        "explode" : false,
                                        "schema" : {
                                            "type" : "string"
                                        }
                                    }
                                },
                                "content" : { }
                            }
                            }
                        }
                        }
                    },
                    "components" : {
                        "schemas" : {
                            "PostRequest" : {
                                "type" : "object",
                                "properties" : {
                                    "id" : {
                                        "type" : "string",
                                        "description" : "mock desc"
                                    }
                                }
                            },
                            "Post200ApplicationJsonResponse" : {
                                "type" : "object",
                                "properties" : {
                                    "message" : {
                                        "type" : "string",
                                        "description" : "Success message",
                                        "example" : "Unauthorized Error"
                                    }
                                }
                            },
                            "Post401ApplicationJsonResponse" : {
                                "type" : "object",
                                "properties" : {
                                    "message" : {
                                        "type" : "string",
                                        "description" : "Auth Failed",
                                        "example" : "OK"
                                    }
                                }
                            },
                            "Post500ApplicationJsonResponse" : {
                                "type" : "object",
                                "properties" : {
                                    "message" : {
                                        "type" : "string",
                                        "description" : "Submission Failed",
                                        "example" : "Error"
                                    }
                                }
                            }
                        },
                        "securitySchemes" : {}
                    }
                }
            }
    /]

[/#macro]