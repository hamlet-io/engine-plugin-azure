[#ftl]

[#macro azure_spa_arm_state occurrence parent={} baseState={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#-- Baseline component lookup --]
  [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData" ], false, false )]
  [#local baselineComponentIds = getBaselineComponentIds(baselineLinks, "cmk", "vmKeyPair", "", "container")]
  [#local operationsBlobContainer = getExistingReference(baselineComponentIds["OpsData"])]
  
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
        "CONFIG_FILE": formatRelativePath(configFilePath, configFileName)
      },
      "Roles": {
        "Inbound": {},
        "Outbound": {}
      }
    }
  ]

[/#macro]