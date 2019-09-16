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
                "Names" : "Website",
                "Children" : [
                    {
                        "Names" : "CustomDomain",
                        "Type" : STRING_TYPE,
                        "Default" : ""
                    },
                    {
                        "Names" : "HttpsOnly",
                        "Description" : "Support Only Https traffic?",
                        "Type" : BOOLEAN_TYPE,
                        "Default" : true
                    }
                ]
            },
            {
                "Names" : "Encryption",
                "Children" : [
                    {
                        "Names" : "Enabled",
                        "Type" : BOOLEAN_TYPE,
                        "Default" : false
                    },
                    {
                        "Names" : "KeySource",
                        "Type" : STRING_TYPE,
                        "Values" : [ "Microsoft.Storage", "Microsoft.Keyvault" ],
                        "Default" : "Microsoft.Keyvault"
                    },
                    {
                        "Names" : "Services",
                        "Type" : ARRAY_OF_STRING_TYPE,
                        "Description" : "The Services to enable encryption for. Valid values are 'blob' and/or 'file'.",
                        "Default" : [ "" ]
                    }
                ]
            },
            {
                "Names" : "Secrets",
                "Children" : [
                    {
                        "Names" : "KeyName",
                        "Type" : STRING_TYPE,
                        "Default" : ""
                    },
                    {
                        "Names" : "KeyVersion",
                        "Type" : STRING_TYPE,
                        "Default" : ""
                    },
                    {
                        "Names" : "KeyUri",
                        "Type" : STRING_TYPE,
                        "Default" : ""
                    }
                ]
            },
            {
                "Names" : "Access",
                "Children" : [
                    {
                        "Names" : "SubnetIds",
                        "Description" : "A list of the subnet Ids to grant Allow permission.",
                        "Type" : ARRAY_OF_STRING_TYPE,
                        "Default" : [ "" ]
                    },
                    {
                        "Names" : "IPAddressRanges",
                        "Description" : "A list of IP ranges to grant Allow permission.",
                        "Type" : ARRAY_OF_STRING_TYPE,
                        "Default" : [ "" ]
                    },
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
                        "Default" : "None"
                    }
                ]
            },
            {
                "Names" : "CORSBehaviours",
                "Children" : [
                    {
                        "Names" : "AllowedOrigins",
                        "Type" : ARRAY_OF_STRING_TYPE,
                        "Default" : [ "" ]
                    },
                    {
                        "Names" : "AllowedMethods",
                        "Type" : ARRAY_OF_STRING_TYPE,
                        "Default" : [ "" ]
                    },
                    {
                        "Names" : "MaxAge",
                        "Type" : NUMBER_TYPE,
                        "Description" : "The max age, in seconds.",
                        "Default" : ""
                    },
                    {
                        "Names" : "ExposedHeaders",
                        "Type" : ARRAY_OF_STRING_TYPE,
                        "Default" : [ "" ]
                    },
                    {
                        "Names" : "AllowedHeaders",
                        "Type" : ARRAY_OF_STRING_TYPE,
                        "Default" : [ "" ]
                    }
                ]
            }
        ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_STORAGE_SERVICE
        ]
/]