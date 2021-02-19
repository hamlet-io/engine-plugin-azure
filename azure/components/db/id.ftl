[#ftl]

[@addResourceGroupInformation
    type=DB_COMPONENT_TYPE
    attributes=[
        {
            "Names": "AutoGrow",
            "Description" : "Allow Database storage to grow automatically as the capacity limit is reached.",
            "Types": STRING_TYPE,
            "Values" : [ "Enabled", "Disabled" ],
            "Default" : "Disabled"
        },
        {
            "Names" : "Secrets",
            "SubObjects" : true,
            "Children" : secretChildrenConfiguration
        },
        {
            "Names" : "SecretSettings",
            "Description" : "Configuration for Secrets that are defined in Settings.",
            "Children" : secretSettingsConfiguration
        }
    ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_DB_POSTGRES_SERVICE,
            AZURE_DB_MYSQL_SERVICE,
            AZURE_KEYVAULT_SERVICE
        ]
/]