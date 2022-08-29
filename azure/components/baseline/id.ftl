[#ftl]
[@addResourceGroupInformation
    type=BASELINE_COMPONENT_TYPE
    attributes=
        [
            {
                "Names" : "Lifecycle",
                "Children" : [
                    {
                        "Names" : "BlobRetentionDays",
                        "Types" : NUMBER_TYPE,
                        "Default" : ""
                    },
                    {
                        "Names" : "BlobAutoSnapshots",
                        "Types" : BOOLEAN_TYPE,
                        "Default" : false
                    }
                ]
            },
            {
                "Names" : "Certificate",
                "AttributeSet" : CERTIFICATE_ATTRIBUTESET_TYPE
            },
            {
                "Names" : "Access",
                "Children" : [
                    {
                        "Names" : "DirectoryService",
                        "Description" : "The directory service that is used for authentication. 'None' or 'AADDS'.",
                        "Types" : STRING_TYPE,
                        "Default" : ""
                    }
                ]
            },
            {
                "Names" : "AdministratorGroups",
                "Description" : "The set of administrator groups controlling access to keyvault",
                "Types" : ARRAY_OF_STRING_TYPE,
                "Default" : ["9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3"]
            }
        ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_BASELINE_PSEUDO_SERVICE,
            AZURE_KEYVAULT_SERVICE,
            AZURE_STORAGE_SERVICE
        ]
/]


[@addResourceGroupAttributeValues
    type=BASELINE_COMPONENT_TYPE
    provider=AZURE_PROVIDER
    extensions=[
      {
        "Names" : "Profiles",
        "Children" : [
          {
            "Names" : "Storage",
            "Description" : "Controls the storage configuration for the baseline storage account",
            "Types" : STRING_TYPE,
            "Default" : "default"
          }
        ]
      }
    ]
/]
