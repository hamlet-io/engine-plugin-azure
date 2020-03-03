[#ftl]

[#macro azure_lb_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#-- Name Processing --]
    [#local id = formatResourceId(AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE, core.FullName)]
    [#local name = formatName(AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE, core.FullName)]
    [#local ipId = formatResourceId(AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE, core.FullName)]
    [#local ipName = formatName(AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE, core.FullName)]

    [#switch solution.Engine]
        [#case "application"]
            [#-- Use Application Gateway resource --]
            [#local resourceType = AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE]
            [#break]

        [#case "network"]
            [#-- Use Load Balancer resource --]
            [#-- TODO(rossmurr4y)                       --]
            [#-- Implement network load balancer engine --]
            [#local resourceType = "COTFatal: Unsupported LB Engine"]
            [#break]

        [#default]
            [#local resourceType = "COTFatal: Unknown LB Engine"]
            [#break]

    [/#switch]


    [#assign componentState =
        {
            "Resources" : {
                "lb" : {
                    "Id" : id,
                    "Name" : name,
                    "Type" : resourceType,
                    "Sku" : "Standard_v2",
                    "Reference" : getReference(id, name)
                },
                "publicIP" : {
                    "Id" : ipId,
                    "Name" : ipName,
                    "Type" : AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE,
                    "Reference" : getReference(ipId, ipName)
                }
            },
            "Attributes" : {
                "INTERNAL_FQDN" : getExistingReference(id, DNS_ATTRIBUTE_TYPE)
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]

[/#macro]

[#macro azure_lbport_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local parentCore = parent.Core]
    [#local parentSolution = parent.Configuration.Solution]
    [#local parentState = parent.State]

    [#local engine = parentSolution.Engine]
    [#local internalFqdn = parentState.Attributes["INTERNAL_FQDN"] ]
    [#local lb = parentState.Resources["lb"]]

    [#-- Check source and destination ports --]
    [#local mapping = solution.Mapping!core.SubComponent.Name ]
    [#local source = (portMappings[mapping].Source)!"" ]
    [#local destination = (portMappings[mapping].Destination)!"" ]
    [#local sourcePort = (ports[source])!{} ]
    [#local destinationPort = (ports[destination])!{} ]

    [#local sourcePortId = sourcePort.Id!source]
    [#local sourcePortName = sourcePort.Name!source]
    [#local destinationPortId = destinationPort.Id!destination]
    [#local destinationPortName = destinationPort.Name!destination]

    [#local listenerId = formatDependentResourceId(lb.Type, parentCore.Id, source, "listener")]
    [#local listenerName = formatName(source, destination)]
    [#local routingRuleId = formatDependentResourceId(lb.Type, parentCore.Id, sourcePortId, solution.Priority)]
    [#local backendSettingsId = formatDependentResourceId(lb.Type, parentCore.Id, destinationPortId, "settings")]
    [#local backendAddressPoolId = formatDependentResourceId(lb.Type, parentCore.Id, destinationPortId, "addresses")]
    [#local backendAddressPoolName = formatName(destinationPortId, "addresses")]
    [#local frontendPortId = formatDependentResourceId(lb.Type, parentCore.Id, sourcePortId, "frontendport")]
    [#local frontendIPConfigId = formatResourceId(lb.Type, parentCore.Id, "frontendip")]
    [#local frontendIPConfigName = formatName(destinationPortName, "frontendIP")]
    [#local gatewayIPConfigId = formatResourceId(lb.Type, parentCore.Tier.Name, "ipconfig")]
    [#local gatewayIPConfigName = formatName(parentCore.Tier.Name, "ipconfig")]

    [#local domainRedirectRules = {} ]
    [#if (sourcePort.Certificate)!false ]
        [#local certificateObject = getCertificateObject(solution.Certificate, segmentQualifiers, sourcePortId, sourcePortName)]

        [#local hostName = getHostName(certificateObject, occurrence)]
        [#local primaryDomainObject = getCertificatePrimaryDomain(certificateObject)]

        [#local fqdn = formatDomainName(hostName, primaryDomainObject)]
        [#local scheme = "https"]

        [#-- Redirect any secondary domains --]
        [#list getCertificateSecondaryDomains(certificateObject) as secondaryDomainObject]
            [#local id = formatResourceId(lb.Type, parentCore.Id, sourcePortId, solution.Priority + secondaryDomainObject?counter)]
            [#local name = formatName(sourcePortId, "redirect")]
            [#local domainRedirectRules +=
                {
                    id : {
                        "Id" : id,
                        "Name" : name,
                        "Priority" : solution.Priority + secondaryDomainObject?counter,
                        "RedirectFrom" : formatDomainName(hostName, secondaryDomainObject),
                        "SubReference" : getSubReference(lb.Id, lb.Name, "redirectConfigurations", name)
                    }
                }
            ]
        [/#list]
    [#else]
        [#local fqdn = internalFqdn ]
        [#local scheme ="http" ]
    [/#if]

    [#local path = ""]
    [#if solution.Path != "default" ]
        [#if (solution.Path)?ends_with("*") ]
            [#local path = solution.Path?remove_ending("*")?ensure_ends_with("/") ]
        [#else]
            [#local path = solution.Path ]
        [/#if]
    [/#if]

    [#local url = scheme + "://" + fqdn  ]
    [#local internalUrl = scheme + "://" + internalFqdn ]

    [#assign componentState =
            {
                "Resources" : {
                    "listener" : {
                        "Id" : listenerId,
                        "Name" : listenerName,
                        "SubReference" : getSubReference(lb.Id, lb.Name, "httpListeners", listenerName)
                    },
                    "frontendPort" : {
                        "Id" : frontendPortId,
                        "Name" : sourcePortId,
                        "SubReference" : getSubReference(lb.Id, lb.Name, "frontendPorts", sourcePortId)
                    },
                    "frontendIPConfiguration" : {
                        "Id" : frontendIPConfigId,
                        "Name" : frontendIPConfigName,
                        "SubReference" : getSubReference(lb.Id, lb.Name, "frontendIPConfigurations", frontendIPConfigName)
                    },
                    "gatewayIPConfiguration" : {
                        "Id" : gatewayIPConfigId,
                        "Name" : gatewayIPConfigName,
                        "SubReference" : getSubReference(lb.Id, lb.Name, "gatewayIPConfigurations", gatewayIPConfigName)
                    },
                    "routingRule" : {
                        "Id" : routingRuleId,
                        "Name" : sourcePortName,
                        "Priority" : solution.Priority,
                        "SubReference" : getSubReference(lb.Id, lb.Name, "requestRoutingRules", sourcePortName)
                    },
                    "backendSettingsCollection" : {
                        "Id" : backendSettingsId,
                        "Name" : destinationPortName,
                        "SubReference" : getSubReference(lb.Id, lb.Name, "backendHttpSettingsCollection", destinationPortName)
                    },
                    "backendAddressPool" : {
                        "Id" : backendAddressPoolId,
                        "Name" : backendAddressPoolName,
                        "SubReference" : getSubReference(lb.Id, lb.Name, "backendAddressPools", backendAddressPoolName)
                    }
                } +
                attributeIfContent("redirectConfiguration", domainRedirectRules),
                "Attributes" : {
                    "LB" : lb.Id,
                    "ENGINE" : engine,
                    "FQDN" : fqdn,
                    "URL" : url + path,
                    "INTERNAL_FQDN" : internalFqdn,
                    "INTERNAL_URL" : internalUrl + path,
                    "PATH" : path,
                    "PORT" : sourcePort.Port,
                    "SOURCE_PORT" : sourcePort.Port,
                    "DESTINATION_PORT" : destinationPort.Port
                },
                "Roles" : {
                    "Inbound" : {},
                    "Outbound" : {}
                }
            }
        ]

[/#macro]