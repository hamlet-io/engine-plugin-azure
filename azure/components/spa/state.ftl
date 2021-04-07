[#ftl]

[#macro azure_spa_arm_state occurrence parent={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#local configFilePath =
    formatRelativePath(
      getOccurrenceSettingValue(occurrence, "SETTINGS_PREFIX"),
      "config")]
  [#local configFileName = "config.json" ]

  [#-- SPA's hosted in a Storage Account require a named $web blob container --]
  [#local storageAccountId = formatResourceId(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.Id)]
  [#local storageAccountName =
    formatAzureResourceName(
      formatName(core.ShortName, getExistingReference(formatSegmentSeedId())),
      AZURE_STORAGEACCOUNT_RESOURCE_TYPE
    )
  ]
  [#local blobId = formatResourceId(AZURE_BLOBSERVICE_RESOURCE_TYPE, core.Id)]
  [#local blobName = formatAzureResourceName(
      "default",
      AZURE_BLOBSERVICE_RESOURCE_TYPE,
      storageAccountName
    )
  ]

  [#local containerId = formatResourceId(AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, core.Id)]
  [#local containerName = formatAzureResourceName(
    r"$web",
    AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE,
    blobName
  )]

  [#assign componentState =
    {
      "Resources": {
        "site": {
          "Id": formatResourceId(SPA_COMPONENT_TYPE, core.Id),
          "Deployed": true,
          "Type": SPA_COMPONENT_TYPE
        },
        "storageAccount" : {
            "Id" : storageAccountId,
            "Name" : storageAccountName,
            "Type" : AZURE_STORAGEACCOUNT_RESOURCE_TYPE,
            "Reference" : getReference(storageAccountId, storageAccountName)
        },
        "blobService" : {
            "Id" : blobId,
            "Name" : blobName,
            "Type" : AZURE_BLOBSERVICE_RESOURCE_TYPE,
            "Reference" : getReference(blobId, blobName)
        },
        "container" : {
          "Id" : containerId,
          "Name" : containerName,
          "Type" : AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE,
          "Reference" : getReference(containerId, containerName)
        }
      },
      "Attributes": {
        "FORWARDING_PATH": formatRelativePath(
            getOccurrenceSettingValue(occurrence, "SETTINGS_PREFIX"), 
            "spa")?ensure_starts_with('/'),
        "CONFIG_PATH_PATTERN": solution.ConfigPathPattern,
        "CONFIG_FILE": formatRelativePath(configFilePath, configFileName),
        "BACKEND_PORT" : solution.Port.HTTPS
      },
      "Roles": {
        "Inbound": {},
        "Outbound": {}
      }
    }
  ]

[/#macro]
