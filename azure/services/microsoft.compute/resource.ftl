[#ftl]

[@addResourceProfile
  service=AZURE_VIRTUALMACHINE_SERVICE
  resource=AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-03-01",
      "type" : "Microsoft.Compute/virtualMachineScaleSets",
      "outputMappings" : {
        REFERENCE_ATTRIBUTE_TYPE : {
          "Property" : "id"
        },
        NAME_ATTRIBUTE_TYPE : {
          "Property" : "name"
        },
        ALLOCATION_ATTRIBUTE_TYPE : {
          "Property" : "identity.principalId"
        }
      }
    }
/]

[@addResourceProfile
  service=AZURE_VIRTUALMACHINE_SERVICE
  resource=AZURE_VIRTUALMACHINE_SCALESET_EXTENSION_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-12-01",
      "type" : "Microsoft.Compute/virtualMachineScaleSets/extensions",
      "outputMappings" : {}
    }
/]

[#function getVirtualMachineProfileLinuxConfigPublicKey
  path=""
  data=""]

  [#return
    {} +
    attributeIfContent("path", path) +
    attributeIfContent("keyData", data)
  ]

[/#function]

[#function getVirtualMachineProfileLinuxConfig
  publicKeys
  disablePasswordAuth=true]

  [#return
    {
      "ssh" : {
        "publicKeys" : publicKeys
      }
    } +
    attributeIfTrue("disablePasswordAuthentication", disablePasswordAuth, disablePasswordAuth)
  ]

[/#function]

[#function getVirtualMachineProfileWindowsConfig
  autoUpdatesEnabled=false
  timeZone=""
  unattendContent=[]
  winRM={}]

  [#return
    {} +
    attributeIfTrue("enableAutomaticUpdates", autoUpdatesEnabled, autoUpdatesEnabled) +
    attributeIfContent("timeZone", timeZone) +
    attributeIfContent("additionalUnattendContent", unattendContent) +
    attributeIfContent("winRM", winRM)
  ]

[/#function]

[#function getVirtualMachineNetworkProfileNICConfig
  id
  name
  primary=false
  ipConfigurations=[]
  nsgRef=""]

  [#return
    {
      "id": id,
      "name": name,
      "properties" : {
        "primary" : primary,
        "ipConfigurations" : ipConfigurations
      } +
      attributeIfContent("networkSecurityGroup", nsg, { "id" : nsgRef })
    }
  ]

[/#function]

[#function getVirtualMachineNetworkProfile
  networkInterfaceConfigurations=[]
  healthProbe={}]
  [#return
    {} +
    attributeIfContent("networkInterfaceConfigurations", networkInterfaceConfigurations) +
    attributeIfContent("healthProbe", healthProbe)]
[/#function]

[#function getVirtualMachineProfile
  storageAccountType
  imagePublisher
  imageOffer
  image
  nicConfigurations
  linuxConfiguration={}
  vmNamePrefix=""
  adminName=""
  windowsConfiguration={}
  priority="Regular"
  imageVersion="latest"
  licenseType=""]

  [#return
    {
      "osProfile" : {} +
        attributeIfContent("computerNamePrefix", vmNamePrefix) +
        attributeIfContent("adminUsername", adminName) +
        attributeIfContent("linuxConfiguration", linuxConfiguration) +
        attributeIfContent("windowsConfiguration", windowsConfiguration),
      "storageProfile" : {
        "osDisk" : {
          "createOption" : "FromImage",
          "managedDisk" : {
          } +
          attributeIfContent("storageAccountType", storageAccountType)
        },
        "imageReference" : {
          "publisher" : imagePublisher,
          "offer" : imageOffer,
          "sku" : image,
          "version" : imageVersion
        }
      },
      "networkProfile" : nicConfigurations,
      "priority" : priority
    } +
    attributeIfContent("licenseType", licenseType)
  ]

[/#function]

[#macro createVMScaleSet
  id
  name
  location
  skuName
  skuTier
  skuCapacity
  vmProfile
  vmUpgradeMode="Manual"
  identity={}
  zones=[]
  dependsOn={}]

  [@armResource
    id=id
    name=name
    profile=AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE
    location=location
    sku=
      {
        "name" : skuName,
        "tier" : skuTier,
        "capacity" : skuCapacity
      }
    identity=identity
    dependsOn=dependsOn
    zones=zones
    properties=
      {
        "upgradePolicy" : {
          "mode" : vmUpgradeMode
        },
        "virtualMachineProfile" : vmProfile
      }
  /]

[/#macro]

[#macro createVMScaleSetExtension
  id
  name
  scriptConfig
  settings={}
  protectedSettings={}
  addTimestamp=true
  provisionAfterExtensions=[]
  dependsOn=[]]

  [#-- Settings should be listed even when empty.                            --]
  [#-- addTimestamp will force a deployment even when template is unchanged. --]
  [#local timestamp = datetimeAsString(.now)?replace("[^\\d]", '', 'r')]

  [@armResource
    id=id
    name=name
    profile=AZURE_VIRTUALMACHINE_SCALESET_EXTENSION_RESOURCE_TYPE
    dependsOn=dependsOn
    properties={
      "settings" : settings +
        attributeIfTrue("timestamp", addTimestamp, timestamp?number)
    } +
      attributeIfContent("publisher", (scriptConfig.Publisher)!"") +
      attributeIfContent("type", (scriptConfig.Type.Name)!"") +
      attributeIfContent("typeHandlerVersion", (scriptConfig.Type.HandlerVersion)!"") +
      attributeIfTrue("autoUpgradeMinorVersion", scriptConfig.AutoUpgradeOnMinorVersion, scriptConfig.AutoUpgradeOnMinorVersion ) +
      attributeIfContent("protectedSettings", protectedSettings) +
      attributeIfContent("provisionAfterExtensions", provisionAfterExtensions)
  /]

[/#macro]
