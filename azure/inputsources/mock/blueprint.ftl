[#ftl]

[#-- Intial seeding of settings data based on input data --]
[#macro azure_input_mock_blueprint_seed ]
    [@addBlueprint
        blueprint=
        {
            "Account": {
                "Region": "westus",
                "ProviderId": "0123456789"
            },
            "Product": {
                "Region": "westus"
            }
        }
    /]
[/#macro]
