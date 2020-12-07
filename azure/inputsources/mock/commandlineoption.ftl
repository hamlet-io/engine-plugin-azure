[#ftl]

[#macro azure_input_mock_commandlineoption_seed]

    [@addCommandLineOption
        option=
            {
                "Regions" : {
                    "Segment" : "westus",
                    "Account" : "westus"
                },
                "Deployment" : {
                    "ResourceGroup" : {
                        "Name" : "mockRG"
                    },
                    "Unit" : {
                        "Name" : getDeploymentUnit()
                    }
                }
            }
    /]

[/#macro]