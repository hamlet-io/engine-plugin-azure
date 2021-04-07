[#ftl]

[#macro azure_spa_arm_state occurrence parent={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#-- Baseline component lookup --]
  [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData" ], false, false )]
  [#local baselineResources = baselineLinks["OpsData"].State.Resources]
  [#local operationsBlobContainer = baselineResources["container"]]

  [#local configFilePath =
    formatRelativePath(
      getOccurrenceSettingValue(occurrence, "SETTINGS_PREFIX"),
      "config")]
  [#local configFileName = "config.json" ]

  [#-- SPA's hosted in a Storage Account require a named $web blob container --]
  [#local storageAccountId = formatResourceId(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.Id)]
  [#local storageAccountName =
    formatAzureResourceName(
      formatName(core.ShortName, segmentSeedValue),
      AZURE_STORAGEACCOUNT_RESOURCE_TYPE
    )
  ]
  [#local blobName = formatAzureResourceName(
      r"$web",
      AZURE_BLOBSERVICE_RESOURCE_TYPE,
      storageAccountName
    )
  ]

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
            "Type" : AZURE_STORAGEACCOUNT_RESOURCE_TYPE
        },
        "blobService" : {
            "Id" : formatResourceId(AZURE_BLOBSERVICE_RESOURCE_TYPE, core.Id),
            "Name" : blobName,
            "Type" : AZURE_BLOBSERVICE_RESOURCE_TYPE
        }
      },
      "Attributes": {
        "FORWARDING_PATH": formatRelativePath(
            getOccurrenceSettingValue(occurrence, "SETTINGS_PREFIX"), 
            "spa")?ensure_starts_with('/'),
        "CONFIG_PATH_PATTERN": solution.ConfigPathPattern,
        "CONFIG_STORAGE_CONTAINER": operationsBlobContainer,
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
