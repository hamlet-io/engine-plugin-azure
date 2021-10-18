[#ftl]
[#--
  Currently, all the typical Gateway resources have been created within the
  Network component due to Azure specific requirements. The Gateway will
  be utilised in a greater capacity when it comes to implimenting
  privateEndpoint resources. Leaving large portions of the macro
  intact so as to outline the future structure.
--]
[#macro azure_gateway_arm_deployment_generationcontract occurrence]
  [@addDefaultGenerationContract subsets="template" /]
[/#macro]

[#macro azure_gateway_arm_deployment occurrence]

  [#local gwCore = occurrence.Core]
  [#local gwSolution = occurrence.Configuration.Solution]
  [#local gwResources = occurrence.State.Resources]

  [#-- Network Lookups & Links --]
  [#-- As full subnet name is vnet/subnet, retrieve both & format --]
  [#local occurrenceNetwork = getOccurrenceNetwork(occurrence)]
  [#local networkLink = occurrenceNetwork.Link!{} ]
  [#local networkLinkTarget = getLinkTarget(occurrence, networkLink, false) ]

  [#if ! networkLinkTarget?has_content ]
      [@fatal message="Network could not be found" context=networkLink /]
      [#return]
  [/#if]

  [#local networkResources = networkLinkTarget.State.Resources ]
  [#local networkVnetResource = networkResources["vnet"]]
  [#local subnetResource = getSubnet(gwCore.Tier, networkResources)]

  [#local sourceIPAddressGroups = gwSolution.SourceIPAddressGroups]
  [#local sourceCidrs = getGroupCIDRs(sourceIPAddressGroups, true, occurrence)]

  [#local sku = getSkuProfile(occurrence, gwCore.Type)]

  [#-- Private DNS Zone Creation --]
  [#--

    [#if deploymentSubsetRequired(NETWORK_GATEWAY_COMPONENT_TYPE, true)]

    [#local dnsZoneId = gwResources["dnsZone"].Id]
    [#local dnsZoneName = gwResources["dnsZone"].Name]
    [#local dnsZoneLinkId = gwResources["vnetLink"].Id]
    [#local dnsZoneLinkName = formatAzureResourceName(gwResources["vnetLink"].Name, getResourceType(dnsZoneLinkId), dnsZoneName)]

    [@createPrivateDnsZone
      id=dnsZoneId
      name=dnsZoneName
    /]

    [@createPrivateDnsZoneVnetLink
      id=dnsZoneLinkId
      name=dnsZoneLinkName
      vnetId=getReference(networkResources["vnet"])
      autoRegistrationEnabled=true
    /]

  [/#if]
  --]

  [#--
    Currently there are no "destination" requirements for an Azure Gateway component
    (they are created as a part of the Subnet resource in the Network component).
    The below structure is left available to ensure simple implimentation of Private
    Links at a later time.
  --]

  [#switch gwSolution.Engine]
    [#case "private"]
      [#local virtualNetworkGateway = gwResources["virtualNetworkGateway"] ]
      [#local gatewayPublicIPs = gwResources["publicIPs"]]

      [#list gatewayPublicIPs?values as gatewayIP ]
        [@createPublicIPAddress
            id=gatewayIP.Id
            name=gatewayIP.Name
            location=getRegion()
            allocationMethod="Static"
        /]
      [/#list]

      [@createAzVirtualNetworkGateway
          id=virtualNetworkGateway.Id
          name=virtualNetworkGateway.Name
          location=getRegion()
          sku=sku
          vpnGatewayGeneration=sku.Generation
          gatewayType="Vpn"
          enableBGP=gwSolution.BGP.Enabled
          asn=gwSolution.BGP.ASN
          activeActive=true
          publicIPReferences=gatewayPublicIPs?values?map( x -> x.Reference )
          subnetReference=subnetResource.Reference
          vpnType=gwSolution["azure:engine:Private"].RoutingPolicy
          dependsOn=gatewayPublicIPs?values?map( x -> x.Reference )
      /]
      [#break]
  [/#switch]

  [#list occurrence.Occurrences![] as subOccurrence]

    [@debug message="Suboccurrence" context=subOccurrence enabled=false /]

    [#local core = subOccurrence.Core]
    [#local solution = subOccurrence.Configuration.Solution]
    [#local resources = subOccurrence.State.Resources]

    [#switch gwSolution.Engine]
      [#case "vpcendpoint"]
      [#case "privateservice"]
        [#local networkEndpoints = getNetworkEndpoints(solution.NetworkEndpointGroups, "a", getRegion())]
        [#list networkEndpoints as id, networkEndpoint]
          [#if networkEndpoint.Type == "PrivateLink"]
            [#-- TODO(rossmurr4y): impliment Azure Private Links --]
          [/#if]
        [/#list]
        [#break]
      [#case "private"]
        [#break]

      [#default]
        [@fatal
          message="Unsupported Gateway Engine."
          context=gwSolution.Engine
        /]
    [/#switch]

  [/#list]
[/#macro]
