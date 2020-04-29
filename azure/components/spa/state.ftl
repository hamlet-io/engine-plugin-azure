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

  [#assign componentState =
    {
      "Resources": {
        "site": {
          "Id": formatResourceId(SPA_COMPONENT_TYPE, core.Id),
          "Deployed": true,
          "Type": SPA_COMPONENT_TYPE
        }
      },
      "Attributes": {
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
