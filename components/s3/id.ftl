[#ftl]
[@addResourceGroupInformation
    type=S3_COMPONENT_TYPE
    attributes=[]
    [#-- TODO(rossmurr4y): make this variable name provider independent --]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_STORAGE_SERVICE
        ]
/]