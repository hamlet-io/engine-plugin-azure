[#ftl]

[#-- Intial seeding of settings data based on input data --]
[#macro azure_input_mock_blueprint_seed ]
    [@addBlueprint
        blueprint=
        {
            "Account": {
                "Region": AZURE_REGION_MOCK_VALUE,
                "ProviderId": AZURE_SUBSCRIPTION_MOCK_VALUE
            },
            "Product": {
                "Region": AZURE_REGION_MOCK_VALUE
            }
        }
    /]
[/#macro]
