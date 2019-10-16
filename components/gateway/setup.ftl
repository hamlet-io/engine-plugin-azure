[#ftl]

[#macro azure_gateway_arm_segment occurrence]

  [#if deploymentSubsetRequired("genplan", false)]
    [@addDefaultGenerationPlan subsets="template" /]
    [#return]
  [/#if]

  [#local gwCore = occurrence.Core]
  [#local gwSolution = occurrence.Configuration.Solution]
  [#local gwResources = occurrence.State.Resources]

  [#local occurrenceNetwork = getOccurrenceNetwork(occurrence) ]
  [#local networkLink = occurrenceNetwork.Link!{} ]

  [#if !networkLink?has_content]
    [@fatal
      message="Tier Network configuration incomplete"
      context=
        {
          "networkTier" : occurrenceNetwork,
          "Link" : networkLink
        }
    /]
  [/#if]

  [#local networkLinkTarget = getLinkTarget(occurrence, networkLink, false) ]
  [#if ! networkLinkTarget?has_content ]
    [@fatal message="Network could not be found" context=networkLink /]
  [/#if]
  [#local networkResources = networkLinkTarget.State.Resources]

  [#local sourceIPAddressGroups = gwSolution.SourceIPAddressGroups]
  [#local sourceCidrs = getGroupCIDRs(sourceIPAddressGroups, true, occurrence)]

  [#-- Private DNS Zone Creation --]
  [#if deploymentSubsetRequired(NETWORK_GATEWAY_COMPONENT_TYPE, true)]

    [@createPrivateDnsZone 
      id=gwResources["dnsZone"].Id 
      name=gwResources["dnsZone"].Name
      location=regionId
    /]

    [@createPrivateDnsZoneVnetLink 
      id=gwResources["vnetLink"].Id
      name=gwResources["vnetLink"].Name
      location=regionId
      vnetId=networkResources["vnet"].Id
    /]

  [/#if]

  [#list occurrence.Occurrences![] as subOccurrence]

    [@debug message="Suboccurrence" context=subOccurrence enabled=false /]

    [#local core = subOccurrence.Core]
    [#local solution = subOccurrence.Configuration.Solution]
    [#local resources = subOccurrence.State.Resources]

    [#switch gwSolution.Engine]
      [#case "vpcendpoint"]
        [#local privateEndpointResources = resources["privateEndpoints"]!{}]
        [#if deploymentSubsetRequired(NETWORK_GATEWAY_COMPONENT_TYPE, true)]
          [#list privateEndpointResources as privateEndpointId, privateEndpoint]
            
            [@createPrivateEndpoint
              id=privateEndpoint.Id
              name=privateEndpoint.Name
              location=regionId
              subnetId=""
              privateLinkServiceConnections=[]
            /]

          [/#list]
        [/#if]
        [#break]
    [/#switch]

  [/#list]
[/#macro]