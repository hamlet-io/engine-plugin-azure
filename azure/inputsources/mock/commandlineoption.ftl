[#ftl]
[#assign AZURE_REGION_MOCK_VALUE = "westus" ]
[#assign AZURE_SUBSCRIPTION_MOCK_VALUE = "0123456789" ]
[#assign AZURE_RESOURCEGROUP_MOCK_VALUE = "mockRG" ]

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