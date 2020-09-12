[#ftl]
[@addResourceGroupInformation
    type=S3_COMPONENT_TYPE
    attributes=
        [
            {
                "Names" : "Lifecycle",
                "Children" : [
                    {
                        "Names" : "BlobRetentionDays",
                        "Type" : NUMBER_TYPE,
                        "Default" : ""
                    },
                    {
                        "Names" : "BlobAutoSnapshots",
                        "Type" : BOOLEAN_TYPE,
                        "Default" : false
                    }
                ]
            },
            {
                "Names" : "Certificate",
                "Children" : certificateChildConfiguration                
            },
            {
                "Names" : "Access",
                "Children" : [
                    {
                        "Names" : "DirectoryService",
                        "Description" : "The directory service that is used for authentication. 'None' or 'AADDS'.",
                        "Type" : STRING_TYPE,
                        "Default" : ""
                    },
                    {
                        "Names" : "PublicAccess",
                        "Type" : STRING_TYPE,
                        "Values" : [ "Container", "Blob", "None" ],
                        "Default" : [ "None" ]
                    }
                ]
            }
        ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_STORAGE_SERVICE,
            AZURE_KEYVAULT_SERVICE,
            AZURE_RESOURCES_SERVICE
        ]
/]