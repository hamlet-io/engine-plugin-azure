[#ftl]

[#macro azure_baseline_arm_state occurrence parent={} baseState={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]
  
  [#assign componentState=
    {
      "Resources" : {
        "storageAccount" : {
            "Id" : formatResourceId(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.ShortName),
            "Type" : AZURE_STORAGEACCOUNT_RESOURCE_TYPE
        },
        "blobService" : {
            "Id" : formatResourceId(AZURE_BLOBSERVICE_RESOURCE_TYPE, core.Id),
            "Name" : "default",
            "Type" : AZURE_BLOBSERVICE_RESOURCE_TYPE
        },
        "keyVault" : {
            "Id" : formatResourceId(AZURE_KEYVAULT_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_KEYVAULT_RESOURCE_TYPE, core.ShortName),
            "Type" : AZURE_KEYVAULT_RESOURCE_TYPE
        },
        "keyVaultAccessPolicy" : {
            "Id" : formatResourceId(AZURE_KEYVAULT_ACCESS_POLICY_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_KEYVAULT_ACCESS_POLICY_RESOURCE_TYPE, core.ShortName),
            "Type" : AZURE_KEYVAULT_ACCESS_POLICY_RESOURCE_TYPE
        }
      },
      "Attributes" : {},
      "Roles" : {
        "Inbound": {},
        "Outbound": {}
      }
    }
  ]
[/#macro]

[#macro azure_baselinedata_arm_state occurrence parent={} baseState={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#assign componentState =
    {
      "Resources": {
        "container" : {
          "Id" : formatResourceId(AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, core.Id),
          "Name" : formatName(AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE, core.SubComponent.Id),
          "Type" : AZURE_BLOBSERVICE_CONTAINER_RESOURCE_TYPE
        }
      },
      "Attributes": {},
      "Roles": {
        "Inbound": {},
        "Outbound": {}
      }
    }
  ]
[/#macro]

[#macro azure_baselinekey_arm_state occurrence parent={} baseState={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]
  
  [#local resources = {}]

  [#switch solution.Engine]
    [#case "cmk"]

      [#local resources +=
        {
          "cmkLocalKeyPair" : {
            "Id" : formatResourceId(AZURE_CMK_RESOURCE_TYPE, core.Id),
            "Name" : formatName(LOCAL_PRIVATE_KEY_RESOURCE_TYPE, core.SubComponent.Id),
            "PrivateKey" : formatName(".azure", accountObject.Id, regionId, "cmk", "prv") + ".pem",
            "PublicKey" : formatName(".azure", accountObject.Id, regionId, "cmk", "crt") + ".pem",
            "Type" : LOCAL_PRIVATE_KEY_RESOURCE_TYPE
          },
          "cmkKeyPair" : {
            "Id" : formatResourceId(AZURE_KEY_PAIR_RESOURCE_TYPE, core.SubComponent.Id),
            "Name" : formatName(AZURE_KEY_PAIR_RESOURCE_TYPE, core.ShortName, "cmk"),
            "Type" : AZURE_KEY_PAIR_RESOURCE_TYPE
          }
        }
      ]
    [#case "ssh"]
      [#local resources +=
        {
          "sshLocalKeyPair" : {
            "Id" : formatResourceId(LOCAL_SSH_PRIVATE_KEY_RESOURCE_TYPE, core.SubComponent.Id),
            "Name" : formatName(LOCAL_SSH_PRIVATE_KEY_RESOURCE_TYPE, core.ShortName),
            "PrivateKey" : formatName(".azure", accountObject.Id, regionId, "ssh", "prv") + ".pem",
            "PublicKey" : formatName(".azure", accountObject.Id, regionId, "ssh", "crt") + ".pem",
            "Type" : LOCAL_SSH_PRIVATE_KEY_RESOURCE_TYPE
          },
          "vmKeyPair" : {
            "Id" : formatResourceId(AZURE_KEY_PAIR_RESOURCE_TYPE, core.SubComponent.Id),
            "Name" : formatName(AZURE_KEY_PAIR_RESOURCE_TYPE, core.ShortName),
            "Type" : AZURE_KEY_PAIR_RESOURCE_TYPE
          }
        }
      ]
    [#case "oai"]
      [@fatal
        message="OAI Key Type is unsupported by the Azure plugin."
        detail=solution.Engine
        context=occurrence
      /]
    [#default]
      [@fatal
        message="Unsupported Key Type"
        detail=solution.Engine
        context=occurrence
      /]
  [/#switch]

  [#assign componentState =
    {
      "Resources": resources,
      "Attributes": {},
      "Roles": {
        "Inbound": {},
        "Outbound": {}
      }
    }
  ]
[/#macro]