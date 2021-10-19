[#ftl]

[@addResourceGroupInformation
    type=DIRECTORY_COMPONENT_TYPE
    attributes=[
        {
            "Names" : "Profiles",
            "Children" : [
                {
                    "Names" : "Sku",
                    "Types" : STRING_TYPE,
                    "Default" : "default"
                }
            ]
        }
    ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_AAD_SERVICE
        ]
/]


[@addResourceGroupAttributeValues
    type=DIRECTORY_COMPONENT_TYPE
    provider=AZURE_PROVIDER
    extensions=[
        {
            "Names" : "Engine",
            "Values" : [ "AADDirectoryServices" ],
            "Default" : "azure:AADDirectoryServices"
        },
        {
            "Names" : "Size",
            "Values" : ["Sku"],
            "Default" : [ "azure:Sku" ]
        }
    ]
/]
