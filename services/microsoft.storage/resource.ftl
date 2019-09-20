[#ftl]

[#assign STORAGE_ACCOUNT_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "UseRef" : true
        },
        NAME_ATTRIBUTE_TYPE : {
            "Property" : "name"
        },
        URL_ATTRIBUTE_TYPE : {
            "Property" : "properties.primaryEndpoints.web"
        },
        REGION_ATTRIBUTE_TYPE : {
            "Property" : "properties.location"
        }
    }
]

[#assign STORAGE_BLOB_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "Property" : "id"
        },
        NAME_ATTRIBUTE_TYPE : {
            "Property" : "name"
        }
    }
]

[#assign STORAGE_BLOB_CONTAINER_OUTPUT_MAPPINGS =
    {
        REFERENCE_ATTRIBUTE_TYPE : {
            "Property" : "id"
        },
        NAME_ATTRIBUTE_TYPE : {
            "Property" : "name"
        }
    }
]
[#assign outputMappings += 
    {
        AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE : STORAGE_BLOB_CONTAINER_OUTPUT_MAPPINGS,
        AZURE_BLOBSERVICE_RESOURCE_TYPE : STORAGE_BLOB_OUTPUT_MAPPINGS,
        AZURE_STORAGEACCOUNT_RESOURCE_TYPE : STORAGE_ACCOUNT_OUTPUT_MAPPINGS
    }
]

[#function getStorageSku tier replication reasonCodes...]
    [#return
        {
            "name" : [tier, replication]?join("_")
        } +
        attributeIfContent("restrictions", asArray(reasonCodes))
    ]
[/#function]

[#function getStorageCustomDomain name useSubDomainName=true]
    [#return
        {
            "name": name,
            "useSubDomainName": useSubDomainName
        }
    ]
[/#function]

[#function getStorageEncryptionServices blob=false file=false]
    [#return
        {} +
        attributeIfTrue("blob", blob, { "enabled" : true }) + 
        attributeIfTrue("file", file, { "enabled" : true })
    ]
[/#function]

[#function getStorageEncryptionKeyvaultproperties name="" keyversion="" uri=""]
    [#return
        {} +
        attributeIfContent("keyname", name) +
        attributeIfContent("keyversion", keyversion) +
        attributeIfContent("keyvaulturi", keyvaulturi)
    ]
[/#function]

[#function getStorageEncryption keySource services={} keyvaultproperties={}]
    [#return
        {
            "keySource": keySource
        } +
        attributeIfContent("services", services) +
        attributeIfContent("keyvaultproperties", keyvaultproperties)
    ]
[/#function]

[#function getStorageNetworkAcls 
    defaultAction 
    ipRules=[]
    virtualNetworkRules=[]
    bypass=""]

    [#return
        {
            "defaultAction": defaultAction
        } +
        attributeIfContent("ipRules", asArray(ipRules)) +
        attributeIfContent("virtualNetworkRules", asArray(virtualNetworkRules)) +
        attributeIfContent("bypass", bypass)
    ]
[/#function]

[#function getStorageNetworkAclsVirtualNetworkRules id action="" state=""]
   [#return
        {
            "id" : id
        } +
        attributeIfContent("action", action) +
        attributeIfContent("state", state)
    ]
[/#function]

[#function getStorageNetworkAclsIpRules value action=""]
    [#return
        {
            "value" : value
        } + 
        attributeIfContent("action", action)
    ]
[/#function]

[#function getStorageAzureFilesIdentityBasedAuthentication service]
    [#return { "directoryServiceOptions" : service } ]
[/#function]

[#-- all attributes are mandatory on CorsRules object --]
[#function getStorageBlobServiceCorsRules
    allowedOrigins
    allowedMethods
    maxAgeInSeconds
    exposedHeaders
    allowedHeaders
    ]

    [#return
        {
            "allowedOrigins": asArray(allowedOrigins),
            "allowedMethods": asArray(allowedMethods),
            "maxAgeInSeconds": maxAgeInSeconds,
            "exposedHeaders": asArray(exposedHeaders),
            "allowedHeaders": asArray(allowedHeaders)
        }
    ]
[/#function]

[#function getStorageBlobServiceDeleteRetentionPolicy days]
    [#return { "enabled": true, "days": days }]
[/#function]

[#macro createStorageAccount
    name
    sku
    location
    kind
    tags={}
    customDomain={}
    encryption={}
    networkAcls={}
    accessTier=""
    azureFilesIdentityBasedAuthentication={}
    supportsHttpsTrafficOnly=true
    isHnsEnabled=false
    dependsOn=[]]

    [@armResource
        name=name
        type="Microsoft.Storage/storageAccounts"
        apiVersion="2019-04-01"
        kind=kind
        location=location
        tags=tags
        identity={ "type" : "SystemAssigned" }
        sku=sku
        outputs=STORAGE_ACCOUNT_OUTPUT_MAPPINGS
        properties=
            {} +
            attributeIfContent("customDomain", customDomain) +
            attributeIfContent("encryption", encryption) +
            attributeIfContent("networkAcls", networkAcls) +
            attributeIfContent("accessTier", accessTier) +
            attributeIfContent("azureFilesIdentityBasedAuthentication", azureFilesIdentityBasedAuthentication) +
            attributeIfTrue("supportsHttpsTrafficOnly", !supportsHttpsTrafficOnly, false) +
            attributeIfTrue("isHnsEnabled", isHnsEnabled, true)
        dependsOn=dependsOn
    /]
[/#macro]

[#macro createBlobService
    name
    corsRules=[]
    deleteRetentionPolicy={}
    automaticSnapshotPolicyEnabled=false
    resources=[]
    dependsOn=[]]

    [@armResource
        name=name
        type="Microsoft.Storage/storageAccounts/blobServices"
        apiVersion="2019-04-01"
        dependsOn=dependsOn
        resources=resources
        outputs=STORAGE_BLOB_OUTPUT_MAPPINGS
        properties=
            {
                "defaultServiceVersion": "2019-04-01"
            } + 
            attributeIfContent("corsRules", asArray(corsRules)) +
            attributeIfContent("deleteRetentionPolicy", deleteRetentionPolicy) + 
            attributeIfTrue("automaticSnapshotPolicyEnabled", automaticSnapshotPolicyEnabled, automaticSnapshotPolicyEnabled)
    /]
[/#macro]

[#macro createBlobServiceContainer
    name
    type="Microsoft.Storage/storageAccounts/blobServices/containers"
    apiVersion="2019-04-01"
    publicAccess=false
    metadata={}
    resources=[]
    dependsOn=[]]

    [@armResource
        name=name
        resources=resources
        dependsOn=dependsOn
        outputs=STORAGE_BLOB_CONTAINER_OUTPUT_MAPPINGS
        properties=
            {
                "publicAccess": publicAccess
            } +
            attributeIfContent("metadata", metadata)
    /]
[/#macro]