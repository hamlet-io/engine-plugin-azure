[#ftl]

[@registerInputSeeder
    id=AZURE_INPUT_SEEDER
    description="Azure provider inputs"
/]

[@addSeederToConfigPipeline
    stage=MASTERDATA_SHARED_INPUT_STAGE
    seeder=AZURE_INPUT_SEEDER
/]

[@addSeederToConfigPipeline
    stage=FIXTURE_SHARED_INPUT_STAGE
    seeder=AZURE_INPUT_SEEDER
/]

[@addSeederToConfigPipeline
    sources=[MOCK_SHARED_INPUT_SOURCE]
    stage=COMMANDLINEOPTIONS_SHARED_INPUT_STAGE
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
            getArrayIntersection(
                getFilterAttribute(filter, "Region")
                azure_cmdb_regions?keys
            )
        ]
        [#if requiredRegions?has_content]
            [#local regions = getObjectAttributes(azure_cmdb_regions, requiredRegions) ]
        [#else]
            [#local regions = azure_cmdb_regions]
        [/#if]
        [#return
            mergeObjects(
                state,
                {
                    "Masterdata" :
                        azure_cmdb_masterdata +
                        {
                            "Regions" : regions
                        }
                }
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
            mergeObjects(
                state,
                {
                    "Blueprint" :
                    {
                        "Account": {
                            "Region": AZURE_REGION_MOCK_VALUE,
                            "ProviderId": AZURE_SUBSCRIPTION_MOCK_VALUE
                        },
                        "Product": {
                            "Region": AZURE_REGION_MOCK_VALUE
                        }
                    }
                }
            )
        ]
    [/#if]
    [#return state]

[/#function]

[#function azure_configseeder_commandlineoptions_mock filter state]

    [#if filterAttributeContainsValue(filter, "Provider", AZURE_PROVIDER) ]
        [#return
            mergeObjects(
                state,
                {
                    "CommandLineOptions" : {
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
                }
            )
        ]
    [/#if]
    [#return state]
[/#function]
