[#ftl]

[#-- Intial seeding of settings data based on input data --]
[#macro azure_input_mock_blueprint_seed ]
    [@addBlueprint
        blueprint=
        {
            "Account": {
                "Region": "westus",
                "AzureId": "12345678-abcd-efgh-ijkl-123456789012"
            },
            "Product": {
                "Region": "westus"
            }
        }
    /]
[/#macro]
