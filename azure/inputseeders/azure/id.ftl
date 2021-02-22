[#ftl]

[@addInputSeeder
    id=AZURE_INPUT_SEEDER
    description="Azure provider inputs"
/]

[@addSeederToInputStage
    inputStage=MASTERDATA_SHARED_INPUT_STAGE
    inputSeeder=AZURE_INPUT_SEEDER
/]

[@addSeederToInputStage
    inputStage=MOCK_SHARED_INPUT_STAGE
    inputSeeder=AZURE_INPUT_SEEDER
/]

[@addSeederToInputStage
    inputSources=[MOCK_SHARED_INPUT_SOURCE]
    inputStage=COMMANDLINEOPTIONS_SHARED_INPUT_STAGE
    inputSeeder=AZURE_INPUT_SEEDER

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

[#function azure_inputseeder_masterdata filter state]

    [#if getFilterAttribute(filter, "Provider")?seq_contains(AZURE_PROVIDER)]
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
    [#else]
        [#return state]
    [/#if]

[/#function]

[#function azure_inputseeder_mock filter state]

    [#if getFilterAttribute(filter, "Provider")?seq_contains(AZURE_PROVIDER)]
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
    [#else]
        [#return state]
    [/#if]

[/#function]

[#function azure_inputseeder_commandlineoption_mock filter state]

    [#if getFilterAttribute(filter, "Provider")?seq_contains(AZURE_PROVIDER)]
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
                            },
                            "Unit" : {
                                "Name" : getDeploymentUnit()
                            }
                        }
                    }
                }
            )
        ]
    [/#if]
[/#function]
