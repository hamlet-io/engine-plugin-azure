[#ftl]

[@addResourceGroupInformation
    type=DB_COMPONENT_TYPE
    attributes=[
        {
            "Names": "AutoGrow",
            "Description" : "Allow Database storage to grow automatically as the capacity limit is reached.",
            "Type": STRING_TYPE,
            "Values" : [ "Enabled", "Disabled" ],
            "Default" : "Disabled"
        }
    ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_DB_POSTGRES_SERVICE,
            AZURE_KEYVAULT_SERVICE
        ]
/]