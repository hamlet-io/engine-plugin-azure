[#ftl]

[#macro azure_computecluster_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local scaleSetId  = formatResourceId(AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE, core.ShortName)]
    [#local nicId       = formatResourceId(AZURE_NETWORK_INTERFACE_RESOURCE_TYPE, core.ShortName)]
    [#local nsgRuleId   = formatResourceId(AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE, core.ShortName)]
    [#local ipPrefixId  = formatResourceId(AZURE_PUBLIC_IP_ADDRESS_PREFIX_RESOURCE_TYPE, core.ShortName)]
    
    [#local scalesetName  = formatAzureResourceName(core.ShortName, AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE)]
    [#local nicName       = formatAzureResourceName(core.ShortName, AZURE_NETWORK_INTERFACE_RESOURCE_TYPE)]
    [#local nsgRuleName   = formatAzureResourceName(core.ShortName, AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE)]
    [#local ipPrefixName  = formatAzureResourceName(core.ShortName, AZURE_PUBLIC_IP_ADDRESS_PREFIX_RESOURCE_TYPE)]

    [#local autoScaling = {}]
    [#if solution.ScalingPolicies?has_content ]
        [#list solution.ScalingPolicies as name, scalingPolicy]

            [#local autoScaleId = formatResourceId(AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE, core.ShortName + name)]
            [#local autoScaleName = formatAzureResourceName(core.ShortName + name, AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE)]

            [#local autoScaling += 
                {
                    name : {
                        "Id" : autoScaleId,
                        "Name" : autoScaleName,
                        "Type" : AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE,
                        "Reference" : getReference(autoScaleId, autoScaleName)
                    }
                }
            ]

        [/#list]
    [/#if]

    [#assign componentState =
        {
            "Resources" : {
                "scaleSet" : {
                    "Id" : scaleSetId,
                    "Name" : scalesetName,
                    "Type" : AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE,
                    "Reference" : getReference(scaleSetId, scalesetName)
                },
                "networkInterface" : {
                    "Id" : nicId,
                    "Name" : nicName,
                    "Type" : AZURE_NETWORK_INTERFACE_RESOURCE_TYPE,
                    "Reference": getReference(nicId, nicName)
                },
                "nsgRule": {
                    "Id" : nsgRuleId,
                    "Name" : nsgRuleName,
                    "Type" : AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE,
                    "Reference" : getReference(nsgRuleId, nsgRuleName)
                },
                "publicIPPrefix": {
                    "Id" : ipPrefixId,
                    "Name" : ipPrefixName,
                    "Type" : AZURE_PUBLIC_IP_ADDRESS_PREFIX_RESOURCE_TYPE,
                    "Reference" : getReference(ipPrefixId, ipPrefixName)
                },
                "scalePolicies" : autoScaling
            },
            "Attributes" : {},
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]
[/#macro]