[#ftl]

[@registerInputSeeder
    id=AZURE_INPUT_SEEDER
    description="Azure provider inputs"
/]

[@registerInputTransformer
    id=AZURE_INPUT_SEEDER
    description="Azure provider inputs"
/]

[@addSeederToConfigPipeline
    sources=[MOCK_SHARED_INPUT_SOURCE]
    stage=COMMANDLINEOPTIONS_SHARED_INPUT_STAGE
    seeder=AZURE_INPUT_SEEDER
/]

[@addSeederToConfigPipeline
    stage=MASTERDATA_SHARED_INPUT_STAGE
    seeder=AZURE_INPUT_SEEDER
/]

[@addSeederToConfigPipeline
    stage=FIXTURE_SHARED_INPUT_STAGE
    seeder=AZURE_INPUT_SEEDER
/]

[@addTransformerToConfigPipeline
    stage=NORMALISE_SHARED_INPUT_STAGE
    transformer=AZURE_INPUT_SEEDER
/]

[@addSeederToStatePipeline
    stage=FIXTURE_SHARED_INPUT_STAGE
    seeder=AZURE_INPUT_SEEDER
/]

[@addSeederToStatePipeline
    stage=SIMULATE_SHARED_INPUT_STAGE
    seeder=AZURE_INPUT_SEEDER
/]

[#macro azure_inputloader path]
    [#assign azure_cmdb_regions =
        (
            getPluginTree(
                path,
                {
                    "AddStartingWildcard" : false,
                    "AddEndingWildcard" : false,
                    "MinDepth" : 1,
                    "MaxDepth" : 1,
                    "FilenameGlob" : "regions.json"
                }
            )[0].ContentsAsJSON
        )!{}
    ]
    [#assign azure_cmdb_masterdata =
        (
            getPluginTree(
                path,
                {
                    "AddStartingWildcard" : false,
                    "AddEndingWildcard" : false,
                    "MinDepth" : 1,
                    "MaxDepth" : 1,
                    "FilenameGlob" : "masterdata.json"
                }
            )[0].ContentsAsJSON
        )!{}
    ]
[/#macro]

[#-- Globals to ensure consistency across input type --]
[#assign AZURE_REGION_MOCK_VALUE = "westus" ]
[#assign AZURE_SUBSCRIPTION_MOCK_VALUE = "0123456789" ]
[#assign AZURE_RESOURCEGROUP_MOCK_VALUE = "mockRG" ]
[#assign AZURE_SERVICE_NAME_MOCK_VALUE = "Microsoft.Mock" ]
[#assign AZURE_RESOURCE_TYPE_MOCK_VALUE = "mockResourceType" ]
[#assign AZURE_RESOURCE_NAME_MOCK_VALUE = "mockName" ]
[#assign AZURE_RESOURCE_ID_MOCK_VALUE =
    formatPath(
        true,
        [
            "subscriptions",
            AZURE_SUBSCRIPTION_MOCK_VALUE,
            "resourceGroups",
            AZURE_RESOURCEGROUP_MOCK_VALUE,
            "providers",
            AZURE_SERVICE_NAME_MOCK_VALUE,
            AZURE_RESOURCE_TYPE_MOCK_VALUE,
            AZURE_RESOURCE_NAME_MOCK_VALUE
        ]
    )]
[#assign AZURE_RESOURCE_URL_MOCK_VALUE = "https://mock.local/" ]
[#assign AZURE_RESOURCE_IP_ADDRESS_MOCK_VALUE = "123.123.123.123" ]
[#assign AZURE_BUILD_COMMIT_MOCK_VALUE = "123456789#MockCommit#" ]

[#function azure_configseeder_commandlineoptions_mock filter state]

    [#if filterAttributeContainsValue(filter, "Provider", AZURE_PROVIDER) ]
        [#return
            addToConfigPipelineClass(
                state,
                COMMAND_LINE_OPTIONS_CONFIG_INPUT_CLASS,
                {
                    "Regions" : {
                        "Segment" : AZURE_REGION_MOCK_VALUE,
                        "Account" : AZURE_REGION_MOCK_VALUE
                    },
                    "Deployment" : {
                        "ResourceGroup" : {
                            "Name" : AZURE_RESOURCEGROUP_MOCK_VALUE
                        }
                    }
                }
            )
        ]
    [/#if]
    [#return state]
[/#function]

[#function azure_configseeder_masterdata filter state]

    [#if filterAttributeContainsValue(filter, "Provider", AZURE_PROVIDER) ]
        [#local requiredRegions =
            getMatchingFilterAttributeValues(
                filter,
                "Region",
                azure_cmdb_regions?keys
            )
        ]
        [#if requiredRegions?has_content]
            [#local regions = getObjectAttributes(azure_cmdb_regions, requiredRegions) ]
        [#else]
            [#local regions = azure_cmdb_regions]
        [/#if]
        [#return
            addToConfigPipelineClass(
                state,
                BLUEPRINT_CONFIG_INPUT_CLASS,
                azure_cmdb_masterdata +
                {
                    "Regions" : regions
                },
                MASTERDATA_SHARED_INPUT_STAGE
            )
        ]
    [/#if]
    [#return state]

[/#function]

[#function azure_configseeder_fixture filter state]

    [#if filterAttributeContainsValue(filter, "Provider", AZURE_PROVIDER) ]
        [#local result =
            addToConfigPipelineClass(
                state,
                BLUEPRINT_CONFIG_INPUT_CLASS,
                {
                    "Account": {
                        "Region": AZURE_REGION_MOCK_VALUE,
                        "Provider" : AZURE_PROVIDER,
                        "ProviderId": AZURE_SUBSCRIPTION_MOCK_VALUE
                    },
                    "Product": {
                        "Region": AZURE_REGION_MOCK_VALUE
                    }
                },
                FIXTURE_SHARED_INPUT_STAGE
            )
        ]
        [#local result =
            addToConfigPipelineClass(
                result,
                DEFINITIONS_CONFIG_INPUT_CLASS,
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
                },
                FIXTURE_SHARED_INPUT_STAGE
            )
        ]
        [#return result ]
    [/#if]
    [#return state]

[/#function]

[#-- Normalise arm stack files to state point sets --]
[#-- Note that pseudo stacks use the aws format and are handled via the shared provider --]
[#function azure_configtransformer_normalise filter state]

    [#if filterAttributeContainsValue(filter, "Provider", AZURE_PROVIDER) ]

        [#-- Anything to process? --]
        [#local stackFiles =
            (getConfigPipelineClassCacheForStages(
                state,
                STATE_CONFIG_INPUT_CLASS,
                [
                    FIXTURE_SHARED_INPUT_STAGE,
                    MODULE_SHARED_INPUT_STAGE,
                    CMDB_SHARED_INPUT_STAGE
                ]
            )[STATE_CONFIG_INPUT_CLASS])![]
        ]

        [#-- Normalise each stack to a point set --]
        [#local pointSets = [] ]

        [#-- Looks like arm format? --]
        [#-- TODO(mfl) Remove check for .Content[0] once dynamic CMDB loading operational --]
        [#list stackFiles?filter(s -> ((s.ContentsAsJSON!s.Content[0]).properties)?has_content) as stackFile]
            [#local pointSet = {} ]
            [#local outputs = ((stackFile.ContentsAsJSON!stackFile.Content[0]).properties.outputs)!{} ]

            [#list outputs as key, value]
              [#switch key]
                [#case "resourceGroup"]
                  [#local pointSet += { "ResourceGroup" : value["value"] } ]
                  [#break]
                [#case "deploymentUnit"]
                  [#local pointSet += { "DeploymentUnit" : value["value"] } ]
                  [#break]
                [#case "region"]
                  [#local pointSet += { "Region" : value["value"] } ]
                  [#break]
                [#case "subscription"]
                  [#-- convert Azure languague "subscription to Hamlet language "Account" --]
                  [#local pointSet += { "Account" : value["value"] } ]
                  [#break]
                [#default]
                  [#local pointSet += { key : value["value"] } ]
                  [#break]
              [/#switch]
            [/#list]

            [#if pointSet?has_content ]
                [@debug
                    message="Normalise stack file " + stackFile.FileName!""
                    enabled=false
                /]
                [#local pointSets +=
                    [
                        validatePointSet(
                            mergeObjects(
                                { "Level" : (stackFile.FileName!"")?split('-')[0]},
                                pointSet
                            )
                            )
                    ]
                ]
            [/#if]
        [/#list]

        [#-- Append so as not to loose previously normalised stack info --]
        [#if stackFiles?has_content]
            [#return
                addToConfigPipelineClass(
                    state,
                    STATE_CONFIG_INPUT_CLASS,
                    pointSets,
                    ""
                    APPEND_COMBINE_BEHAVIOuR
                )
            ]
        [/#if]
    [/#if]
    [#return state]
[/#function]

[#function azure_stateseeder_fixture filter state]

    [#local id = state.Id]

    [#switch id?split("X")?last ]
        [#case NAME_ATTRIBUTE_TYPE]
            [#local value = AZURE_RESOURCE_NAME_MOCK_VALUE]
            [#break]
        [#case URL_ATTRIBUTE_TYPE ]
            [#local value = AZURE_RESOURCE_URL_MOCK_VALUE + id ]
            [#break]
        [#case IP_ADDRESS_ATTRIBUTE_TYPE ]
            [#local value = AZURE_RESOURCE_IP_ADDRESS_MOCK_VALUE ]
            [#break]
        [#case REGION_ATTRIBUTE_TYPE ]
            [#local value = AZURE_REGION_MOCK_VALUE ]
            [#break]
        [#default]
            [#--The default value will be an azure resource Id --]
            [#local value = AZURE_RESOURCE_ID_MOCK_VALUE]
            [#break]
    [/#switch]

    [#return
        mergeObjects(
            state,
            {
                "Value" : value
            }
        )
    ]

[/#function]

[#function azure_stateseeder_simulate filter state]
    [#if ! state.Value?has_content]
        [#return azure_stateseeder_fixture(filter, state) ]
    [/#if]
    [#return state]
[/#function]
