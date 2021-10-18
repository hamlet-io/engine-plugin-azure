[#ftl]
[#macro azure_network_arm_deployment_generationcontract occurrence]
  [@addDefaultGenerationContract subsets="template" /]
[/#macro]

[#macro azure_network_arm_deployment occurrence]
  [@debug message="Entering" context=occurrence enabled=false /]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]
  [#local resources = occurrence.State.Resources]

  [#local vnetId = resources["vnet"].Id]
  [#local vnetName = resources["vnet"].Name]
  [#local vnetCIDR = resources["vnet"].Address]
  [#local flowlogs = resources["flowlogs"]!{}]

  [#local vnetDependencies = []]

  [#if deploymentSubsetRequired(NETWORK_COMPONENT_TYPE, true)]

    [#local vnetSubnets = []]

    [#-- 3. Subnets for every tier --]
    [#if (resources["subnets"]!{})?has_content]

      [#local subnetResources = resources["subnets"]]
      [#list subnetResources as tierId,subnets]

        [#local networkTier = getTier(tierId)]
        [#local tierNetwork = getTierNetwork(tierId)]

        [#local networkLink = tierNetwork.Link!{}]
        [#local routeTableId = tierNetwork.RouteTable!""]
        [#local networkACLId = tierNetwork.NetworkACL!""]

        [#if !networkLink?has_content || !routeTableId?has_content || !networkACLId?has_content]
          [@fatal
            message="Tier Network configuration incomplete"
            context=
              tierNetwork +
              {
                "Link" : networkLink,
                "RouteTable" : routeTableId,
                "NetworkACL" : networkACLId
              }
          /]
        [/#if]

        [#local routeTableLink = getLinkTarget(occurrence, networkLink + { "RouteTable" : routeTableId }, false)]
        [#local routeTableResource = (routeTableLink.State.Resources["routeTable"])!{}]

        [#local networkACLLink = getLinkTarget(occurrence, networkLink + { "NetworkACL" : networkACLId }, false)]
        [#local networkACLResource = (networkACLLink.State.Resources["networkSecurityGroup"])!{}]

        [#local subnet = subnets.subnet]

        [#-- Retrieve the NetworkEndpoint's from the Gateway component and prepare the Management Tier subnet for them --]
        [#local networkEndpointGroups = []]
        [#list solution.Links?values as link]
          [#if link?is_hash]

            [#local linkTarget = getLinkTarget(occurrence, link + { "Destination" : "default" }, false)]

            [#if !linkTarget?has_content]
              [#continue]
            [/#if]

            [#local linkTargetConfiguration = linkTarget.Configuration]

            [#switch linkTarget.Core.Type]
              [#case NETWORK_GATEWAY_DESTINATION_COMPONENT_TYPE]
                [#if linkTarget.State.Attributes.Engine = "vpcendpoint" || linkTarget.State.Attributes.Engine = "privateservice" ]
                  [#local linkNetworkEndpointGroups = linkTargetConfiguration.Solution.NetworkEndpointGroups]
                  [#list linkNetworkEndpointGroups as group]
                    [#if !networkEndpointGroups?seq_contains(group)]
                      [#local networkEndpointGroups += [group]]
                    [/#if]
                  [/#list]
                [/#if]
                [#break]
            [/#switch]

          [/#if]
        [/#list]

        [#local networkEndpoints = getNetworkEndpoints(networkEndpointGroups, "a", getRegion())]

        [#local serviceEndpoints = []]
        [#local serviceEndpointPolicies = []]
        [#if tierId == "mgmt"]
          [#list networkEndpoints?keys as endpointId]
            [#local serviceEndpoints += [getSubnetServiceEndpoint(endpointId, [getRegion()])]]
          [/#list]
        [/#if]

        [#-- Add routeTable details if applicable --]
        [#if routeTableResource?has_content]
          [#local vnetDependencies += [getReference(routeTableResource)]]
        [/#if]

        [#if networkACLResource?has_content ]
          [#local vnetDependencies += [ getReference(networkACLResource)]]
        [/#if]

        [#local vnetSubnets += [
          getVnetSubnet(
            subnet.Id,
            subnet.Name,
            subnet.Address,
            [],
            {} + networkACLResource?has_content?then(
                  getSubResourceReference(getReference(networkACLResource)),
                  {}
            ),
            {} + routeTableResource?has_content?then(
                  getSubResourceReference(getReference(routeTableResource)),
                  {}
            ),
            ""
            serviceEndpoints
          )
        ]]
      [/#list]
    [/#if]

    [#-- 1. Vnet --]
    [@createVNet
      id=vnetId
      name=vnetName
      location=getRegion()
      addressSpacePrefixes=[vnetCIDR]
      subnets=vnetSubnets
      dependsOn=vnetDependencies
    /]

    [#-- Sub Components --]
    [#list occurrence.Occurrences![] as subOccurrence]

      [#local core = subOccurrence.Core]
      [#local solution = subOccurrence.Configuration.Solution]
      [#local resources = subOccurrence.State.Resources]

      [@debug message="Suboccurrence" context=subOccurrence enabled=false /]

      [#switch core.Type]
        [#case NETWORK_ROUTE_TABLE_COMPONENT_TYPE]
          [#if ! resources["routeTable"]?? ]
            [#continue]
          [/#if]

          [#local routeTable = resources["routeTable"]]

          [@createRouteTable
            id=routeTable.Id
            name=routeTable.Name
            location=getRegion()
          /]
          [#break]

        [#case NETWORK_ACL_COMPONENT_TYPE ]
          [#if ! resources["networkSecurityGroup"]?? ]
            [#continue]
          [/#if]

          [#local nsg = resources["networkSecurityGroup"]]
          [#local flowlogs = (resources["flowLogs"])!{}]

          [@createNetworkSecurityGroup
            id=nsg.Id
            name=nsg.Name
            location=getRegion()
          /]

          [#list solution.Rules as ruleId, ruleConfig]

            [#if ruleConfig.Source.IPAddressGroups?seq_contains("_localnet")
                  || ruleConfig.Source.IPAddressGroups?seq_contains("__localnet")
                  || ruleConfig.Source.IPAddressGroups?seq_contains("_named:VirtualNetwork")
                  || ruleConfig.Source.IPAddressGroups?seq_contains("__named:VirtualNetwork")]
              [#local direction = "Outbound"]
            [/#if]

            [#if ruleConfig.Destination.IPAddressGroups?seq_contains("_localnet")
                  || ruleConfig.Destination.IPAddressGroups?seq_contains("__localnet")
                  || ruleConfig.Destination.IPAddressGroups?seq_contains("_named:VirtualNetwork")
                  || ruleConfig.Destination.IPAddressGroups?seq_contains("__named:VirtualNetwork")]
              [#local direction = "Inbound"]
            [/#if]

            [@createNetworkSecurityGroupSecurityRuleWithIPAddressGroup
              id=formatDependentSecurityRuleId(nsg.Id, ruleId)
              name=formatAzureResourceName(
                      formatName(ruleId),
                      getResourceType(
                        formatDependentSecurityRuleId(vnetId, formatName(nsg.Name,ruleId))
                      ),
                      nsg.Name
              )
              occurrence=subOccurrence
              description=description
              destinationPortProfileName=ruleConfig.Destination.Port
              sourceIPAddressGroups=ruleConfig.Source.IPAddressGroups
              destinationIPAdressGroups=ruleConfig.Destination.IPAddressGroups
              access=ruleConfig.Action
              priority=ruleConfig.Priority
              direction=direction
              dependsOn=
                [
                  getReference(nsg.Id, nsg.Name)
                ]
            /]
          [/#list]

          [#-- NetworkWatcher : Flow Logs --]
          [#list flowlogs?values as flowlog]
            [@createNetworkWatcherFlowLog
              id=flowlog.Id
              name=flowlog.Name
              targetResourceId=nsg.Reference
              storageId=flowlog.StorageId
              trafficAnalyticsInterval="0"
              retentionPolicyEnabled=true
              retentionDays="7"
              formatType="JSON"
              formatVersion="0"
              dependsOn=
                [
                  getReference(flowlog.StorageId)
                ]
            /]
          [/#list]

        [#break]
      [/#switch]
    [/#list]
  [/#if]
[/#macro]
