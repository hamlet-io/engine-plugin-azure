[#ftl]

[@addResourceProfile
    service=AZURE_STORAGE_SERVICE
    resource=AZURE_STORAGEACCOUNT_RESOURCE_TYPE
    profile=
        {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Storage/storageAccounts",
            "conditions" : [ "name_to_lower", "globally_unique", "alphanumeric_only", "max_length" ],
            "max_name_length" : 24,
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                },
                NAME_ATTRIBUTE_TYPE : {
                    "Property" : "name"
                },
                DICTIONARY_ATTRIBUTE_TYPE : {
                    "Property" : "properties.primaryEndpoints"
                },
                REGION_ATTRIBUTE_TYPE : {
                    "Property" : "properties.primaryLocation"
                }
            }
        }
/]

[@addResourceProfile
    service=AZURE_STORAGE_SERVICE
    resource=AZURE_BLOBSERVICE_RESOURCE_TYPE
    profile=
        {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Storage/storageAccounts/blobServices",
            "conditions" : [ "name_to_lower", "parent_to_lower" ],
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                }
            }
        }
/]

[@addResourceProfile
    service=AZURE_STORAGE_SERVICE
    resource=AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE
    profile=
        {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Storage/storageAccounts/blobServices/containers",
            "conditions" : [ "name_to_lower", "parent_to_lower" ],
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                },
                NAME_ATTRIBUTE_TYPE : {
                    "Property" : "name"
                }
            }
        }
/]

[@addPseudoResourceProfile
    service=AZURE_STORAGE_SERVICE
    resource=AZURE_QUEUE_RESOURCE_TYPE
/]

[#function getStorageSku tier replication reasonCodes...]
    [#return
        {
            "name" : [tier, replication]?join("_")
        } +
        attributeIfContent("restrictions", reasonCodes)
    ]
[/#function]

[#function getStorageCustomDomain name useSubDomainName=false]
    [#return
        {} +
        attributeIfContent("name", name) +
        attributeIfTrue("useSubDomainName", useSubDomainName, useSubDomainName)
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
        attributeIfContent("ipRules", ipRules) +
        attributeIfContent("virtualNetworkRules", virtualNetworkRules) +
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
            "allowedOrigins": allowedOrigins,
            "allowedMethods": allowedMethods,
            "maxAgeInSeconds": maxAgeInSeconds,
            "exposedHeaders": exposedHeaders,
            "allowedHeaders": allowedHeaders
        }
    ]
[/#function]

[#function getStorageBlobServiceDeleteRetentionPolicy days]
    [#return { "enabled": true, "days": days }]
[/#function]

[#macro createStorageAccount
    id
    name
    sku
    location
    kind
    tags={}
    customDomain={}
    networkAcls={}
    accessTier=""
    azureFilesIdentityBasedAuthentication={}
    supportHttpsTrafficOnly=true
    isHnsEnabled=false
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_STORAGEACCOUNT_RESOURCE_TYPE
        kind=kind
        location=location
        tags=tags
        identity={ "type" : "SystemAssigned" }
        sku=sku
        properties=
            {
                "supportsHttpsTrafficOnly" : supportHttpsTrafficOnly
            } +
            attributeIfContent("customDomain", customDomain) +
            attributeIfContent("networkAcls", networkAcls) +
            attributeIfContent("accessTier", accessTier) +
            attributeIfContent("azureFilesIdentityBasedAuthentication", azureFilesIdentityBasedAuthentication) +
            attributeIfTrue("isHnsEnabled", isHnsEnabled, true)
        dependsOn=dependsOn
    /]
[/#macro]

[#macro createBlobService
    id
    name
    CORSBehaviours=[]
    deleteRetentionPolicy={}
    automaticSnapshotPolicyEnabled=false
    resources=[]
    dependsOn=[]]

    [#assign CORSRules = []]
    [#if CORSBehaviours?has_content]
        [#list asArray(CORSBehaviours) as behaviour]
            [#assign CORSBehaviour = CORSProfiles[behaviour]]
            [#if CORSBehaviour?has_content]
                [#assign CORSRules += [
                    {
                        "allowedHeaders": CORSBehaviour.AllowedHeaders,
                        "allowedMethods": CORSBehaviour.AllowedMethods,
                        "allowedOrigins": CORSBehaviour.AllowedOrigins,
                        "exposedHeaders": CORSBehaviour.ExposedHeaders,
                        "maxAgeInSeconds": (CORSBehaviour.MaxAge)?c
                    }
                ]

                ]
            [/#if]
        [/#list]
    [/#if]

    [@armResource
        id=id
        name=name
        profile=AZURE_BLOBSERVICE_RESOURCE_TYPE
        dependsOn=dependsOn
        resources=resources
        properties=
            {} +
            attributeIfContent("cors", attributeIfContent("CORSRules", CORSRules)) +
            attributeIfContent("deleteRetentionPolicy", deleteRetentionPolicy) +
            attributeIfTrue("automaticSnapshotPolicyEnabled", automaticSnapshotPolicyEnabled, automaticSnapshotPolicyEnabled)
    /]
[/#macro]

[#macro createBlobServiceContainer
    id
    name
    publicAccess=""
    metadata={}
    resources=[]
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE
        resources=resources
        dependsOn=dependsOn
        properties=
            {} +
            attributeIfContent("publicAccess", publicAccess) +
            attributeIfContent("metadata", metadata)
    /]
[/#macro]

[#-- Convenience Script functions for interacting with Storage --]

[#function getBuildScript filesArrayName registry product occurrence fileName resourceGroup=""]

    [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData"], false, false)]
    [#local storageAccount = baselineLinks["OpsData"].State.Attributes["ACCOUNT_NAME"]]

    [#local container = getOccurrenceSettingValue(occurrence, ["Registries", registry, "Prefix"], true)?remove_ending("/")]
    [#local fileName = getOccurrenceSettingValue(occurrence, ["Registries", registry, "Prefix"], true)?remove_ending("/")?ensure_ends_with(".zip") ]
    [#local path = formatRelativePath(
        product,
        getOccurrenceBuildScopeExtension(occurrence),
        getOccurrenceBuildUnit(occurrence),
        getOccurrenceBuildReference(occurrence),
        fileName
    )]

    [#return
        [
            "az_copy_from_blob" + " " +
                "\"" + storageAccount + "\"" + " " +
                "\"" + container + "\"" + " " +
                "\"" + path + "\"" + " " +
                "\"$\{tmpdir}/" + fileName + "\"" + " " +
                "\"" + resourceGroup + "\" || return $?",
            "#",
            "addToArray" + " " +
               filesArrayName + " " +
               "\"$\{tmpdir}/" + fileName + "\"",
            "#"
        ]
    ]
[/#function]

[#function syncFilesToBlobContainerScript
    filesArrayName
    storageAccount
    container
    destination]

    [#return
        [
            "case $\{DEPLOYMENT_OPERATION} in",
            "  delete)",
            "    az_delete_blob_dir " +
                   "\"" + storageAccount + "\"" + " " +
                   "\"" + destination + "\" || return $?",
            "    ;;",
            "  create|update)",
            "    debug \"FILES=$\{" + filesArrayName + "[@]}\"",
            "    #",
            "    az_sync_with_blob " +
                   "\"" + storageAccount + "\"" + " " +
                   "\"" + container + "\"" + " " +
                   "\"" + destination + "\"" + " " +
                   "\"" + filesArrayName + "\"" + " || return $?",
            "    ;;",
            " esac",
            "#"
        ]
    ]
[/#function]

[#-- Formats a reference to a Storage Account connection string with quotes --]
[#function formatAzureStorageAccountConnectionStringReference storageKey, storageName parameter=""]

    [#local apiVersion = getAzureResourceProfile(AZURE_STORAGEACCOUNT_RESOURCE_TYPE).apiVersion]
    [#return
        "[concat('''DefaultEndpointsProtocol=https;AccountName=', '" + storageName + "', ';AccountKey=', " + storageKey + ", '''')]"]
[/#function]

[#function formatAzureStorageListKeys storageId storageName key=0]
    [#local profile = getAzureResourceProfile(AZURE_STORAGEACCOUNT_RESOURCE_TYPE)]
    [#local resourceId = formatRawArmFunction("resourceId", [profile.type, storageName])]
    [#local args = [ r"keys[" + key + r"]", "value"]]
    [#return formatArmFunction("listKeys", [resourceId, profile.apiVersion], args)]
[/#function]
