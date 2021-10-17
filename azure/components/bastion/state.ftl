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

  [#local nsgId = formatDependentNetworkSecurityGroupId(networkInterfaceId)]
  [#local nsgName = formatName(networkInterfaceName, AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE)]

  [#local nsgRules = {}]
  [#list solution.ComputeInstance.ManagementPorts as mgmtPort ]

    [#local nsgRuleId = formatDependentSecurityRuleId(core.TypedName, mgmtPort)]
    [#local nsgRuleName = formatAzureResourceName(
                              formatName(core.TypedName, mgmtPort),
                              AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE,
                              nsgName)]

    [#local nsgRules += {
        mgmtPort : {
          "Id" : nsgRuleId,
          "Name" : nsgRuleName,
          "Type" : AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE,
          "Reference" : getReference(nsgRuleId, nsgRuleName),
          "Port" : mgmtPort
        }
    }]
  [/#list]

  [#assign componentState =
    {
      "Resources" : {
        "scaleSet" : {
          "Id" : scaleSetId,
          "Name": scaleSetName,
          "Type": AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE,
          "Reference": getReference(scaleSetId, scaleSetName)
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
        "networkSecurityGroup" : {
          "Id" : nsgId,
          "Name" : nsgName,
          "Type" : AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE,
          "Reference" : getReference(nsgId, nsgName)
        },
        "nsgRules" : nsgRules
      },
      "Attributes" : {},
      "Roles" : {
        "Inbound" : {},
        "Outbound" : {}
      }
    }
  ]

[/#macro]
