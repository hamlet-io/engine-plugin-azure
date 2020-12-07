[#ftl]

[#macro azure_bastion_arm_state occurrence parent={} baseState={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#local scaleSetName = formatName(AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE, core.TypedName)]
  [#local scaleSetId = formatResourceId(AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE, core.TypedName)]
  [#local autoScalePolicyName = formatName(AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE, core.TypedName)]
  [#local autoScalePolicyId = formatDependentResourceId(AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE, core.TypedName)]
  [#local networkInterfaceName = formatName(AZURE_NETWORK_INTERFACE_RESOURCE_TYPE, core.TypedName)]
  [#local networkInterfaceId = formatResourceId(AZURE_NETWORK_INTERFACE_RESOURCE_TYPE, core.TypedName)]
  [#local publicIPPrefixName = formatName(AZURE_PUBLIC_IP_ADDRESS_PREFIX_RESOURCE_TYPE, core.TypedName)]
  [#local publicIPPrefixId = formatResourceId(AZURE_PUBLIC_IP_ADDRESS_PREFIX_RESOURCE_TYPE, core.TypedName)]
  [#local publicIPName = formatName(AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE, core.TypedName)]
  [#local publicIPId = formatResourceId(AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE, core.TypedName)]
  [#local nsgRuleName = formatName(AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE, core.TypedName)]
  [#local nsgRuleId = formatResourceId(AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE, core.TypedName)]

  [#assign componentState =
    {
      "Resources" : {
        "scaleSet" : {
          "Id" : scaleSetId,
          "Name": scaleSetName,
          "Type": AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE,
          "Reference": getReference(scalseSetId, scaleSetName)
        },
        "autoScalePolicy" : {
          "Id" : autoScalePolicyId,
          "Name" : autoScalePolicyName,
          "Type" : AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE,
          "Reference" : getReference(autoScalePolicyId, autoScalePolicyName)
        },
        "networkInterface" : {
          "Id" : networkInterfaceId,
          "Name" : networkInterfaceName,
          "Type" : AZURE_NETWORK_INTERFACE_RESOURCE_TYPE,
          "Reference": getReference(networkInterfaceId, networkInterfaceName)
        },
        "publicIPPrefix": {
          "Id" : publicIPPrefixId,
          "Name" : publicIPPrefixName,
          "Type" : AZURE_PUBLIC_IP_ADDRESS_PREFIX_RESOURCE_TYPE,
          "Reference" : getReference(publicIPPrefixId, publicIPPrefixName)
        },
        "publicIP": {
          "Id" : publicIPId,
          "Name" : publicIPName,
          "Type" : AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE,
          "Reference" : getReference(publicIPId, publicIPName)
        },
        "networkSecurityGroupRule": {
          "Id" : nsgRuleId,
          "Name" : nsgRuleName,
          "Type" : AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE,
          "Reference" : getReference(nsgRuleId, nsgRuleName)
        }
      },
      "Attributes" : {},
      "Roles" : {
        "Inbound" : {},
        "Outbound" : {}
      }
    }
  ]

[/#macro]