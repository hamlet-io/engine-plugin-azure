[#ftl]

[#macro azure_baseline_arm_state occurrence parent={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]
  
  [#local segmentSeedId = formatSegmentSeedId() ]
  [#if !(getExistingReference(segmentSeedId)?has_content) ]
    [#local segmentSeedValue = (commandLineOptions.Run.Id + accountObject.Seed)[0..(solution.Seed.Length - 1)]]
  [#else]
    [#local segmentSeedValue = getExistingReference(segmentSeedId) ]
  [/#if]

  [#local storageAccountId = formatResourceId(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.Id)]
  [#local storageAccountName = 
    formatAzureResourceName(
      formatName(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, segmentSeedValue),
      AZURE_STORAGEACCOUNT_RESOURCE_TYPE
    )
  ]

  [#local blobName = formatAzureResourceName(
      "default",
      AZURE_BLOBSERVICE_RESOURCE_TYPE,
      storageAccountName
    )
  ]

  [#local registries = {}]
  [#list occurrence.Configuration.Settings as config,settings]
    [#list settings?keys?filter(s -> s?starts_with("REGISTRIES") && s?ends_with("PREFIX")) as setting]

        [#local registryName = getOccurrenceSettingValue(occurrence, setting)?remove_ending('/')]]
        [#local registries += 
          {
            setting : {
              "Id": formatResourceId(AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, registryName),
              "Name": formatAzureResourceName(
                registryName
                AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE
                blobName
              ),
              "Type" : AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE
            }
          }
        ]

    [/#list]
  [/#list]

  [#assign componentState=
    {
      "Resources" : {
        "segmentSeed": {
          "Id" : segmentSeedId,
          "Value" : segmentSeedValue,
          "Type" : SEED_RESOURCE_TYPE
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
        },
        "keyVault" : {
            "Id" : formatResourceId(AZURE_KEYVAULT_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_KEYVAULT_RESOURCE_TYPE, segmentSeedValue),
            "Type" : AZURE_KEYVAULT_RESOURCE_TYPE
        },
        "keyVaultAccessPolicy" : {
            "Id" : formatResourceId(AZURE_KEYVAULT_ACCESS_POLICY_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_KEYVAULT_ACCESS_POLICY_RESOURCE_TYPE, core.ShortName),
            "Type" : AZURE_KEYVAULT_ACCESS_POLICY_RESOURCE_TYPE
        },
        "registries" : registries
      },
      "Attributes" : {
        "SEED_SEGMENT" : segmentSeedValue
      },
      "Roles" : {
        "Inbound": {},
        "Outbound": {}
      }
    }
  ]
[/#macro]

[#macro azure_baselinedata_arm_state occurrence parent={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#local storageAccountId = parent.State.Resources["storageAccount"].Id]
  [#local storageAccountName = parent.State.Resources["storageAccount"].Name]
  [#local blobName = parent.State.Resources["blobService"].Name]

  [#if solution.Role == "staticWebsite" ]
    [#local containerName = formatAzureResourceName('$web', AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, blobName)]
  [#else]
    [#local containerName = formatAzureResourceName(core.SubComponent.Id, AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, blobName)]
  [/#if]

  [#assign componentState =
    {
      "Resources": {
        "container" : {
          "Id" : formatResourceId(AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, core.Id),
          "Name" : containerName,
          "Type" : AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE
        }
      },
      "Attributes": {
        "ACCOUNT_ID" : storageAccountId,
        "ACCOUNT_NAME" : storageAccountName,
        "PRIMARY_ENDPOINT" : formatDomainName(storageAccountName, "blob.core.windows.net"),
        "QUEUE_ENDPOINT": formatDomainName(storageAccountName, "queue.core.windows.net"),
        "WEB_ENDPOINT": formatDomainName(storageAccountName, "web.core.windows.net")
      },
      "Roles": {
        "Inbound": {},
        "Outbound": {}
      }
    }
  ]
[/#macro]

[#macro azure_baselinekey_arm_state occurrence parent={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]
  
  [#local resources = {}]

  [#switch solution.Engine]
    [#case "cmk"]

      [#local resources +=
        {
          AZURE_CMK_RESOURCE_TYPE : {
            "Id" : formatResourceId(AZURE_CMK_RESOURCE_TYPE, core.SubComponent.Id),
            "Name" : formatName(AZURE_CMK_RESOURCE_TYPE, core.ShortName, "cmk"),
            "Type" : AZURE_CMK_RESOURCE_TYPE
          }
        }
      ]
      [#break]
    [#case "ssh"]
      [#local resources +=
        {
          "vmKeyPair" : {
            "Id" : formatResourceId(AZURE_KEYVAULT_SECRET_RESOURCE_TYPE, core.SubComponent.Id),
            "Name" : formatName(AZURE_KEYVAULT_SECRET_RESOURCE_TYPE, core.ShortName),
            "Type" : AZURE_KEYVAULT_SECRET_RESOURCE_TYPE
          },
          "localKeyPair": {
            "Id" : formatResourceId(LOCAL_SSH_PRIVATE_KEY_RESOURCE_TYPE, core.Id),
            "PublicKey" : formatName(".azure", accountObject.Id, regionId, core.SubComponent.Name),
            "PrivateKey" : formatName(".azure", accountObject.Id, regionId, core.SubComponent.Name),
            "Type" : LOCAL_SSH_PRIVATE_KEY_RESOURCE_TYPE
          }
        }
      ]
      [#break]
    [#case "oai"]
      [#-- "OAI Key Type is unsupported by the Azure plugin." --]
      [#break]
    [#default]
      [@fatal
        message="Unsupported Key Type"
        detail=solution.Engine
        context=occurrence
      /]
      [#break]
  [/#switch]

  [#assign componentState =
    {
      "Resources": resources,
      "Attributes": {
        "KEYVAULT_ID": parent.State.Resources["keyVault"].Id
      },
      "Roles": {
        "Inbound": {},
        "Outbound": {}
      }
    }
  ]
[/#macro]