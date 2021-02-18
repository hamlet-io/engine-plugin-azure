[#ftl]

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

[#macro azure_input_mock_commandlineoption_seed]

    [@addCommandLineOption
        option=
            {
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
    /]

[/#macro]