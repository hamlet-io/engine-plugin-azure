[#ftl]
[@addResourceGroupInformation
    type=S3_COMPONENT_TYPE
    attributes=
        [
            {
                "Names" : "Website",
                "Children" : [
                    {
                        "Names" : "CustomDomain",
                        "Type" : STRING_TYPE,
                        "Default" : ""
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
                        "Values" : [ "Microsoft.Storage", "Microsoft.Keyvault" ]
                        "Default" : "Microsoft.Keyvault"
                    },
                    {
                        "Names" : "Services",
                        "Type" : ARRAY_OF_STRING_TYPE,
                        "Description" : "The Services to enable encryption for. Valid values are 'blob' and/or 'file'.",
                        "Default" : [ ]
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
                        "Description: "A list of IP ranges to grant Allow permission.",
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