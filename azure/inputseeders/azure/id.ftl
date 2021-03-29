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

[#function azure_configseeder_masterdata filter state]

    [#if filterAttributeContainsValue(filter, "Provider", AZURE_PROVIDER) ]
        [#local requiredRegions =
            getMatchingFilterAttributeValues(
                filter,
                "Region",
                aws_cmdb_regions?keys
            )
        ]
        [#if requiredRegions?has_content]
            [#local regions = getObjectAttributes(azure_cmdb_regions, requiredRegions) ]
        [#else]
            [#local regions = azure_cmdb_regions]
        [/#if]
        [#local masterdata =
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

[#function azure_configseeder_fixture filter state]

    [#if filterAttributeContainsValue(filter, "Provider", AZURE_PROVIDER) ]
        [#return
            addToConfigPipelineClass(
                state,
                BLUEPRINT_CONFIG_INPUT_CLASS,
                {
                    "Account": {
                        "Region": AZURE_REGION_MOCK_VALUE,
                        "ProviderId": AZURE_SUBSCRIPTION_MOCK_VALUE
                    },
                    "Product": {
                        "Region": AZURE_REGION_MOCK_VALUE
                    }
                },
                FIXTURE_SHARED_INPUT_STAGE
            )
        ]
    [/#if]
    [#return state]

[/#function]

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

[#-- Normalise arm stack files to state point sets --]
[#function azure_configtransformer_normalise filter state]

    [#if filterAttributeContainsValue(filter, "Provider", AZURE_PROVIDER) ]

        [#-- Anything to process? --]
        [#local stackFiles =
            getConfigPipelineClassCacheForStage(
                state,
                STATE_CONFIG_INPUT_CLASS,
                CMDB_SHARED_INPUT_STAGE
            )![]
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

        [#if stackFiles?has_content]
            [#return
                removeConfigPipelineClassCacheForStage(
                    combineEntities(
                        state,
                        {
                            STATE_CONFIG_INPUT_CLASS : pointSets
                        },
                        APPEND_COMBINE_BEHAVIOUR
                    ),
                    STATE_CONFIG_INPUT_CLASS,
                    CMDB_SHARED_INPUT_STAGE
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