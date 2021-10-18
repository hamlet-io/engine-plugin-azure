[#ftl]

[#macro azure_computecluster_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local storageRole = "StorageBlobDataReader"]

    [#local scaleSetId  = formatResourceId(AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE, core.ShortName)]
    [#local nicId       = formatResourceId(AZURE_NETWORK_INTERFACE_RESOURCE_TYPE, core.ShortName)]
    [#local roleId      = formatResourceId(AZURE_ROLE_ASSIGNMENT_RESOURCE_TYPE, storageRole)]
    [#local autoscaleId = formatResourceId(AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE, core.ShortName)]
    [#local extensionId = formatResourceId(AZURE_VIRTUALMACHINE_SCALESET_EXTENSION_RESOURCE_TYPE, core.ShortName)]

    [#local scalesetName  = formatAzureResourceName(core.ShortName, AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE)]
    [#local nicName       = formatAzureResourceName(core.ShortName, AZURE_NETWORK_INTERFACE_RESOURCE_TYPE)]
    [#local roleName      = userRoles[storageRole].Id]
    [#local autoscaleName = formatAzureResourceName(core.ShortName, AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE)]
    [#local extensionName = formatAzureResourceName(core.ShortName, AZURE_VIRTUALMACHINE_SCALESET_EXTENSION_RESOURCE_TYPE, scalesetName)]

    [#local publicIPId       = formatResourceId(AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE, core.ShortName)]
    [#local publicIPName     = formatAzureResourceName(core.ShortName, AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE)]

    [#-- NSG Rules --]
    [#local nsgId = formatDependentNetworkSecurityGroupId(nicId)]
    [#local nsgName = formatName(networkInterfaceName, AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE)]

    [#local nsgRules = {}]
    [#list solution.Ports?values as port ]
        [#if port.IPAddressGroups?has_content ]

            [#local nsgRuleId     = formatResourceId(AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE, nsgId, port.Name)]
            [#local nsgRuleName   = formatAzureResourceName(port.Name, AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE, nsgName)]

            [#local nsgRules +=
                {
                    port.Name : {
                        "Id" : nsgRuleId,
                        "Name" : nsgRuleName,
                        "Type" : AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE,
                        "Reference" : getReference(nsgRuleId, nsgRuleName),
                        "Port" : port.Name,
                        "IPAddressGroups" : port.IPAddressGroups
                    }
                }]
        [/#if]
    [/#list]

    [#assign componentState =
        {
            "Resources" : {
                "role" : {
                    "Id" : roleId,
                    "Name" : roleName,
                    "Type" : AZURE_ROLE_ASSIGNMENT_RESOURCE_TYPE,
                    "Reference" : getReference(roleId, roleName),
                    "Assignment" : storageRole
                },
                "scaleSet" : {
                    "Id" : scaleSetId,
                    "Name" : scalesetName,
                    "Type" : AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE,
                    "PrincipalId" : getReference(scaleSetId, scaleSetName, ALLOCATION_ATTRIBUTE_TYPE),
                    "Reference" : getReference(scaleSetId, scalesetName)
                },
                "networkSecurityGroup" : {
                    "Id" : nsgId,
                    "Name" : nsgName,
                    "Type" : AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE,
                    "Reference" : getReference(nsgId, nsgName)
                },
                "publicIp" : {
                    "Id" : publicIPId,
                    "Name" : publicIPName,
                    "Type" : AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE,
                    "Reference" : getReference(publicIPId, publicIPName)
                },
                "networkInterface" : {
                    "Id" : nicId,
                    "Name" : nicName,
                    "Type" : AZURE_NETWORK_INTERFACE_RESOURCE_TYPE,
                    "Reference": getReference(nicId, nicName)
                },
                "autoscale" : {
                    "Id" : autoscaleId,
                    "Name" : autoscaleName,
                    "Type" : AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE,
                    "Reference" : getReference(autoscaleId, autoscaleName)
                },
                "bootstrap" : {
                    "Id" : extensionId,
                    "Name" : extensionName,
                    "Type" : AZURE_VIRTUALMACHINE_SCALESET_EXTENSION_RESOURCE_TYPE,
                    "Reference" : getReference(extensionId, extensionName)
                },
                "nsgRules": nsgRules
            },
            "Attributes" : {},
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]
[/#macro]
