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

  [#switch gwSolution.Engine]
    [#case "private"]
      [#local virtualNetworkGateway = gwResources["virtualNetworkGateway"] ]
      [#break]
  [/#switch]

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

  [#local virtualNetworkGWIPConfigurations = []]
  [#local virtualNetworkGWBGPAddresses = []]

  [#list (occurrence.Occurrences![])?filter(x -> x.Configuration.Solution.Enabled ) as subOccurrence]

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

        [#local gatewayIP = resources["publicIP"]]
        [#local ipConfigurationId = formatId("ipConfiguration", core.TypedName)]
        [#local ipConfigurationName = formatName("ipConfiguration", core.TypedName)]

        [#if core.Type == NETWORK_GATEWAY_DESTINATION_COMPONENT_TYPE ]
          [#if (solution.SiteToSite.InsideTunnelCIDRs)?? ]
              [#if ! (((solution.SiteToSite.InsideTunnelCIDRs)![])[0])?ends_with("/32")]
                [@fatal
                  message="Invalid InsideTunnelCIDRs for Azure Virtual Network Gateway"
                  detail="Provide a /32 CIDR for the BBP address that will be used inside the tunnel"
                  context={
                    "Id" : core.RawId,
                    "Address" : solution.SiteToSite.InsideTunnelCIDRs
                  }
                /]
              [/#if]

              [#local virtualNetworkGWBGPAddresses += [
                      getAzVirtualNetworkGatewayBgpAddress(
                        (solution.SiteToSite.InsideTunnelCIDRs[0])?split("/")[0],
                        ipConfigurationName,
                        virtualNetworkGateway.Reference
                      )]]
          [/#if]

          [#local virtualNetworkGWIPConfigurations += [
                      getAzVirtualNetworkGatewayIPConfiguration(
                        ipConfigurationId,
                        ipConfigurationName,
                        gatewayIP.Reference
                        subnetResource.Reference
                      )
          ]]

          [@createPublicIPAddress
              id=gatewayIP.Id
              name=gatewayIP.Name
              location=getRegion()
              allocationMethod="Static"
          /]

        [/#if]

        [#break]

      [#default]
        [@fatal
          message="Unsupported Gateway Engine."
          context=gwSolution.Engine
        /]
    [/#switch]

  [/#list]

  [#switch gwSolution.Engine]
    [#case "private"]
      [#if virtualNetworkGWIPConfigurations?size > 2 || virtualNetworkGWIPConfigurations?size < 1 ]
        [@fatal
          message="Invalid destination count for private gateway"
          detail="Must have 1 or 2 destinations configured for private gateway"
          context={
            "Component" : gwCore.Component.RawId,
            "Destinations" : (occurrence.Occurrences![])?map(
              x -> (core.Type == NETWORK_GATEWAY_DESTINATION_COMPONENT_TYPE?then(core.RawId, "" ))
            )
          }
        /]
      [/#if]

      [@createAzVirtualNetworkGateway
          id=virtualNetworkGateway.Id
          name=virtualNetworkGateway.Name
          location=getRegion()
          sku=sku
          vpnGatewayGeneration=sku.Generation
          gatewayType="Vpn"
          enableBGP=gwSolution.BGP.Enabled
          bgpPeeringAddresses=virtualNetworkGWBGPAddresses
          asn=gwSolution.BGP.ASN
          ipConfigurations=virtualNetworkGWIPConfigurations
          activeActive=(virtualNetworkGWIPConfigurations?size == 2)
          vpnType=gwSolution["azure:engine:Private"].RoutingPolicy
          dependsOn=virtualNetworkGWIPConfigurations?map( x -> x.properties.publicIPAddress.id )
      /]
      [#break]
  [/#switch]
[/#macro]
