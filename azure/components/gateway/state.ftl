[#ftl]

[#macro azure_gateway_arm_state occurrence parent={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]
  [#local engine = solution.Engine ]

  [#local resources = {}]

  [#switch engine ]
    [#case "vpcendpoint"]
    [#case "privateservice"]
      [#--
        A private DNS Zone is required so we can force routing to the endpoint to remain within the
        VNet. If we don't then default routing may send traffic via the Internet.
      --]

      [#local resources += {
        "dnsZone" : {
            "Id" : formatDependentResourceId(AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE, core.Id),
            "Name" : AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE,
            "Type" : AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE
          },
          "vnetLink" : {
            "Id" : formatDependentResourceId(AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE, core.Id),
            "Type" : AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE
          }
      }]
      [#break]

    [#case "private"]

      [#local occurrenceNetwork = getOccurrenceNetwork(occurrence)]
      [#local networkLink = occurrenceNetwork.Link!{} ]
      [#local networkLinkTarget = getLinkTarget(occurrence, networkLink, false) ]

      [#-- private gateway must be in the same resource group as the network ---]
      [#if getOccurrenceDeploymentUnit(occurrence) != getOccurrenceDeploymentUnit(networkLinkTarget) ]
        [@fatal
          message="Virtual Network Gateway must be part of Network deployment"
          detail="Update the deployment:Unit configuration to align the gateway and network"
          context={
            "GatewayId" : core.RawId,
            "NetworkId" : networkLinkTarget.Core.RawId,
            "Gatewaydeployment:Unit" : getOccurrenceDeploymentUnit(occurrence),
            "Networkdeployment:Unit" : getOccurrenceDeploymentUnit(networkLinkTarget)
          }
        /]
      [/#if]

      [#-- Special tier/Subnet required for Virtual Network Gateway --]
      [#if core.Tier.Id != "GatewaySubnet" && core.Tier.Name != "GatewaySubnet" ]
        [@fatal
          message="Virtual Network Gateway must be in a tier called GatewaySubnet"
          context={
            "GatewayId" : core.RawId,
            "Tier" : core.Tier
          }
        /]
      [/#if]

      [#if occurrenceNetwork.RouteTable != "default"
            && occurrenceNetwork.NetworkACL != "_none" ]
        [@fatal
          message="Must use default RouteTable and _none NetworkACL on GatewaySubnet Tier"
          context={
            "RouteTable" : occurrenceNetwork.RouteTable,
            "NetworkACL" : occurrenceNetwork.NetworkACL
          }
        /]
      [/#if]

      [#local virtualNetworkGatewayId = formatResourceId(AZURE_VIRTUAL_NETWORK_GATEWAY_RESOURCE_TYPE, core.TypedName)]
      [#local virtualNetworkGatewayName = formatName(AZURE_VIRTUAL_NETWORK_GATEWAY_RESOURCE_TYPE, core.TypedName)]

      [#local resources +=
        {
          "virtualNetworkGateway" : {
            "Id" : virtualNetworkGatewayId,
            "Name" : virtualNetworkGatewayName,
            "Type" : AZURE_VIRTUAL_NETWORK_GATEWAY_RESOURCE_TYPE,
            "Reference" : getReference(virtualNetworkGatewayId, virtualNetworkGatewayName)
          }
        }]

      [#break]

    [#default]
      [@fatal
        message="Unknown Engine Type"
        context=occurrence.Configuration.Solution
      /]
  [/#switch]

  [#assign componentState =
    {
      "Resources" : resources,
      "Attributes" : {},
      "Roles" : {
        "Inbound" : {},
        "Outbound" : {}
      }
    }
  ]
[/#macro]

[#macro azure_gatewaydestination_arm_state occurrence parent={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#local parentCore = parent.Core]
  [#local parentSolution = parent.Configuration.Solution]
  [#local engine = parentSolution.Engine]

  [#local resources = {}]

  [#switch engine]
    [#case "vpcendpoint"]
    [#case "privateservice"]

      [#local networkEndpoints = getNetworkEndpoints(solution.NetworkEndpointGroups, "a", getRegion())]

      [#list networkEndpoints as id, networkEndpoint]

        [#switch networkEndpoint.Type]
          [#case "Interface"]
            [#break]
          [#case "PrivateLink"]
            [#-- TODO(rossmurr4y): impliment Azure Private Links --]
            [#break]
        [/#switch]

      [/#list]
      [#break]

    [#case "private"]

      [#local virtualNetworkGateway = parent.State.Resources["virtualNetworkGateway"]]

      [#local publicGatewayIPId = formatResourceId(AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE, core.TypedName)]
      [#local publicGatewayIPName = formatName(AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE, core.TypedName)]

      [#local resources = mergeObjects(
        resources,
        {
          "publicIP" : {
            "Id" : publicGatewayIPId,
            "Name" : publicGatewayIPName,
            "Type" : AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE,
            "Reference" : getReference(publicGatewayIPId, publicGatewayIPName)
          }
        }
      )]

      [#break]

    [#default]
        [@fatal
            message="Unknown Engine Type"
            context={
              "Component" : occurrence.Component.RawId,
              "Engine" : occurrence.Configuration.Solution.Engine
            }
        /]
  [/#switch]

  [#assign componentState =
    {
      "Resources" : resources,
      "Attributes" : {
        "Engine" : parentSolution.Engine
      },
      "Roles" : {
        "Inbound" : {},
        "Outbound" : {}
      }
    }
  ]
[/#macro]
