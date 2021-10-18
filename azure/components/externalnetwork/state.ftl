[#ftl]

[#macro azure_externalnetwork_arm_state occurrence parent={} ]
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local networkCIDRs = getGroupCIDRs(solution.IPAddressGroups, true, occurrence)]

    [#assign componentState =
        {
            "Resources" : {},
            "Attributes" : {
                "NETWORK_ADDRESSES" : networkCIDRs?join(",")
            } +
            attributeIfTrue(
                "BGP_ASN",
                solution.BGP.Enabled,
                solution.BGP.ASN
            ),
            "Roles" : {
                "Inbound" : {
                    "networkacl" : {
                        "IPAddressGroups" : solution.IPAddressGroups,
                        "Description" : core.FullName
                    }
                },
                "Outbound" : {
                    "networkacl" : {
                        "Ports" : solution.Ports,
                        "IPAddressGroups" : solution.IPAddressGroups,
                        "Description" : core.FullName
                    }
                }
            }
        }
    ]
[/#macro]


[#macro azure_externalnetworkconnection_arm_state occurrence parent={} ]

    [#local parentAttributes = parent.State.Attributes]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local engine = solution.Engine ]

    [#local resources = {} ]

    [#switch engine ]
        [#case "SiteToSite"]

            [#list solution.Links as id,link]
                [#if link?is_hash]

                    [#local linkTarget = getLinkTarget(occurrence, link) ]

                    [@debug message="Link Target" context=linkTarget enabled=false /]

                    [#if !linkTarget?has_content]
                        [#continue]
                    [/#if]

                    [#local linkTargetCore = linkTarget.Core ]
                    [#local linkTargetConfiguration = linkTarget.Configuration ]
                    [#local linkTargetResources = linkTarget.State.Resources ]
                    [#local linkTargetAttributes = linkTarget.State.Attributes ]

                    [#switch linkTargetCore.Type]
                        [#case NETWORK_GATEWAY_COMPONENT_TYPE ]

                            [#switch solution.Engine ]
                                [#case "SiteToSite" ]

                                    [#local localNetworkGatewayId = formatResourceId(AZURE_LOCAL_NETWORK_GATEWAY_RESOURCE_TYPE, core.Name, id )]
                                    [#local localNetworkGatewayName = formatName(AZURE_LOCAL_NETWORK_GATEWAY_RESOURCE_TYPE, core.Name, id )]

                                    [#local networkConnectionId = formatResourceId(AZURE_CONNECTION_RESOURCE_TYPE, core.Name, id )]
                                    [#local networkConnectionName = formatName(AZURE_CONNECTION_RESOURCE_TYPE, core.Name, id )]

                                    [#local resources = mergeObjects(
                                        resources,
                                        {
                                            "localNetworkGateway" : {
                                                "Id" : localNetworkGatewayId,
                                                "Name" : localNetworkGatewayName,
                                                "Type" : AZURE_LOCAL_NETWORK_GATEWAY_RESOURCE_TYPE,
                                                "Reference" : getReference(localNetworkGatewayId, localNetworkGatewayName)
                                            },
                                            "networkConnection" :{
                                                "Id" : networkConnectionId,
                                                "Name" : networkConnectionName,
                                                "Type" : AZURE_CONNECTION_RESOURCE_TYPE,
                                                "Reference" : getReference(networkConnectionId, networkConnectionName),
                                                "VirtualNetworkId" : getExistingReference(linkTargetResources["virtualNetworkGateway"].Id)
                                            }
                                        }
                                    )]

                                    [#break]
                            [/#switch]
                            [#break]
                    [/#switch]
                [/#if]
            [/#list]

            [#break]
    [/#switch]

    [#assign componentState =
        {
            "Resources" : resources,
            "Attributes" : {
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]
[/#macro]
