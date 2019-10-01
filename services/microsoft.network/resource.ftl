[#ftl]

[#-- 
Some functions are paired with a corresponding Macro in the event
that a resource can be both defined as a stand-alone Resource OR as
a property within a parent Resource (this is seperate to a sub-resource).

An example being a RouteTable can be both a stand-alone resource, or in 
an object array within a VirtualNetwork's property list. The macro defines
the standalone Resource, whereas the Object function defines the itterable 
property object. This allows flexability for Component authors.
--]

[#assign VIRTUAL_NETWORK_OUTPUT_MAPPINGS = 
  {
    REFERENCE_ATTRIBUTE_TYPE : {
      "Property" : "id"
    }
  }
]

[#assign SUBNET_OUTPUT_MAPPINGS =
  {
    REFERENCE_ATTRIBUTE_TYPE : {
      "Property : "id"
    }
  }
]

[#assign outputMappings += 
  {
    AZURE_VIRTUAL_NETWORK_RESOURCE_TYPE : VIRTUAL_NETWORK_OUTPUT_MAPPINGS,
    AZURE_SUBNET_RESOURCE_TYPE : SUBNET_OUTPUT_MAPPINGS
  }
]

[#function getApplicationSecurityGroupObject 
  resourceId
  location
  tags={}
  properties={}]

  [#return 
    {
      "id" : resourceId,
      "location" : location,
      "properties" : properties
    } +
    attributeIfContent("tags", tags)
  ]
[/#function]
[#macro createApplicationSecurityGroup name location tags={}]
  [@armResource
    name=name
    type="Microsoft.Network/applicationSecurityGroups"
    apiVersion="2019-04-01"
    location=location
    tags=tags
  /]
[/#macro]

[#function getNetworkSecurityGroupSecurityRulesObject
  protocol
  access
  direction
  sourceAddressPrefix=""
  sourceAddressPrefixes=[]
  sourcePortRange=""
  sourcePortRanges=[]
  sourceApplicationSecurityGroups=[]
  destinationPortRange=""
  destinationPortRanges=[]
  destinationAddressPrefix=""
  destinationAddressPrefixes=""
  destinationApplicationSecurityGroups=[]
  description=""
  priority=""]

  [#return
    {
      "access" : access,
      "direction" : direction,
      "protocol" : protocol
    } +
    attributeIfContent("sourceAddressPrefix", sourceAddressPrefix) +
    attributeIfContent("sourceAddressPrefixes", asArray(sourceAddressPrefixes)) +
    attributeIfContent("sourcePortRange", sourcePortRange) +
    attributeIfContent("sourcePortRanges, asArray(sourcePortRanges)) +
    attributeIfContent("sourceApplicationSecurityGroups", asArray(sourceApplicationSecurityGroups)) +
    attributeIfContent("destinationPortRange", destinationPortRange) +
    attributeIfContent("destinationPortRanges", asArray(destinationPortRanges)) +
    attributeIfContent("destinationAddressPrefix", destinationAddressPrefix) +
    attributeIfContent("destinationAddressPrefixes", asArray(destinationAddressPrefixes)) +
    attributeIfContent("destinationApplicationSecurityGroups", asArray(destinationApplicationSecurityGroups)) +
    attributeIfContent("description", description) +
    attributeIfContent("priority", priority)
  ]

[/#function]
[#macro createNetworkSecurityGroupSecurityRules
  name
  properties
  tags={}
  outputs={}
  dependsOn=[]]

  [@armResource
    name=name
    type="Microsoft.Network/networkSecurityGroups/securityRules"
    apiVersion="2019-04-01"
    dependsOn=dependsOn
    properties=properties
    tags=tags
    outputs=outputs
  /]
  
[/#macro]

[#function getRouteTableRouteObject 
  nextHopType 
  addressPrefix="" 
  nextHopIpAddress=""]

  [#return
    {
      "nextHopType" : nextHopType
    } + 
    attributeIfContent("addressPrefix", addressPrefix) +
    attributeIfContent("nextHopIpAddress", nextHopIpAddress)
  ]
[/#function]
[#macro createRouteTableRoute
  name
  properties={}
  dependsOn=[]
  outputs={}
  tags={}]

  [@armResource
    name=name
    type="Microsoft.Network/routeTables/routes"
    apiVersion="2019-02-01"
    properties=properties
    dependsOn=dependsOn
    outputs=outputs
    tags=tags
  /]

[/#macro]

[#function getRouteTableObject
  id=""
  routes=[]
  disableBgpRoutePropagation=false
  ]

  [#return
    {} +
    attributeIfContent("id", getReference(id))
    attributeIfContent("routes", asArray(routes)) +
    attributeIfTrue("disableBgpRoutePropagation", disableBgpRoutePropagation, disableBgpRoutePropagation)
  ]
[/#function]
[#macro createRouteTable
  name
  location=""
  tags={}
  properties={}
  dependsOn=[]
  outputs={}]

  [@armResource
    name=name
    type="Microsoft.Network/routeTables"
    apiVersion="2019-02-01"
    location=location
    tags=tags
    properties=properties
    dependsOn=dependsOn
    outputs=outputs
  /]

[/#macro]

[#function getNetworkSecurityGroupObject
  id=""
  securityRules=[]
  defaultSecurityRules=[]
  resourceGuid=""]

  [#return
    {} +
    attributeIfContent("id", getReference(id)) +
    attributeIfContent("securityRules", asArray(securityRules)) +
    attributeIfContent("defaultSecurityRules", asArray(defaultSecurityRules)) +
    attributeIfContent("resourceGuid", resourceGuid)
  ]
[/#function]
[#macro createNetworkSecurityGroup
  name
  properties
  location=""
  tags={}
  resources=[]
  dependsOn=[]
  outputs={}
  ]

  [@armResource
    name=name
    type="Microsoft.Network/networkSecurityGroups"
    apiVersion="2019-02-01"
    location=location
    tags=tags
    properties=properties
    resources=resources
    dependsOn=dependsOn
    outputs=outputs
  /]
[/#macro]

[#function getServiceEndpointPolicyDefinitionObject
  description=""
  service=""
  serviceResources=[]]

  [#return
    {} +
    attributeIfContent("description", description) +
    attributeIfContent("service", service) +
    attributeIfContent("serviceResources", asArray(serviceResources))
  ]
[/#function]
[#macro createServiceEndpointPolicyDefinition
  name
  properties
  dependsOn=[]
  outputs={}]

  [@armResource
    name=name
    type="Microsoft.Network/serviceEndpointPolicies/serviceEndpointPolicyDefinitions"
    apiVersion="2019-02-01"
    properties=properties
    dependsOn=dependsOn
    outputs=outputs
  /]
[/#macro]

[#function getServiceEndpointPolicyObject
  serviceEndpointPolicyDefinitions=[]]

  [#return
    {} +
    attributeIfContent("serviceEndpointPolicyDefinitions", serviceEndpointPolicyDefinitions)
  ]
[/#function]
[#macro createServiceEndpointPolicy
  name
  properties
  location=""
  dependsOn=[]
  tags={}]

  [@armResource 
    name=name
    type="Microsoft.Network/serviceEndpointPolicies"
    location=location
    apiVersion="2019-02-01"
    properties=properties
    dependsOn=dependsOn
    tags=tags
  /]
[/#macro]

[#function getSubnetDelegation
  id=""
  name=""
  serviceName=""
  actions=[]]

  [#local properties=
    {} +
    attributeIfContent("id", getReference(id))
    attributeIfContent("serviceName", serviceName) +
    attributeIfContent("actions", asArray(actions))
  ]

  [#return
    {} +
    attributeIfContent("id", id) + 
    attributeIfContent("name", name) +
    attributeIfContent("properties", properties)
  ]
[/#function]

[#function getSubnetLinks
  id=""
  resourceName=""
  linkedResourceType=""
  resourceLink=""]

  [#local properties=
    {} +
    attributeIfContent("linkedResourceType", linkedResourceType) +
    attributeIfContent("link", resourceLink)
  ]

  [#return
    {} +
    attributeIfContent("id", getReference(id)) +
    attributeIfContent("name", getReference(resourceName)) +
    attributeIfContent("properties", properties)
  ]
[/#function]
[#function getSubnetServiceEndpoints
  serviceType=""
  locations=[]]

  [#return
    {} + 
    attributeIfContent("service", serviceType) +
    attributeIfContent("locations", asArray(locations))
  ]
[/#function]
[#function getSubnetNatGateway gatewayId=""]
  [#return {} + attributeIfContent("id", gatewayId)]
[/#function]
[#function getSubnetObject
  addressPrefix=""
  addressPrefixes=[]
  networkSecurityGroup={}
  routeTable={}
  natGateway={}
  serviceEndpoints=[]
  serviceEndpointPolicies=[]
  resourceNavigationLinks=[]
  serviceAssociationLinks=[]
  delegations=[]]

  [#return
    {} +
    attributeIfContent("addressPrefix", addressPrefix) +
    attributeIfContent("addressPrefixes", asArray(addressPrefixes)) +
    attributeIfContent("networkSecurityGroup", networkSecurityGroup) +
    attributeIfContent("routeTable", routeTable) +
    attributeIfContent("natGateway", natGateway) +
    attributeIfContent("serviceEndpoints", asArray(serviceEndpoints)) +
    attributeIfContent("serviceEndpointPolicies", asArray(serviceEndpointPolicies)) +
    attributeIfContent("resourceNavigationLinks", asArray(resourceNavigationLinks)) +
    attributeIfContent("serviceAssociationLinks", asArray(serviceAssociationLinks)) +
    attributeIfContent("delegations", asArray(delegations))
  ]
[/#function]
[#macro createSubnet
  name
  properties]

  [@armResource
    name=name
    type="Microsoft.Network/virtualNetworks/subnets"
    apiVersion="2019-02-01"
    properties=properties
  /]
[/#macro]

[#function getVnetPeeringObject
  allowVNetAccess=false
  allowForwardedTraffic=false
  allowGatewayTransit=false
  useRemoteGateways=false
  remoteVirtualNetworkId=""
  remoteAddressSpacePrefixes=[]
  peeringState=""]

  [#local remoteVirtualNetwork =
    {} +
    attributeIfContent("id", remoteVirtualNetworkId)
  ]

  [#local remoteAddressSpace =
    {} +
    attributeIfContent("addressPrefixes", remoteAddressSpacePrefixes)
  ]

  [#return
    {} +
    attributeIfTrue("allowVNetAccess", allowVNetAccess, allowVNetAccess) +
    attributeIfTrue("allowForwardedTraffic", allowForwardedTraffic, allowForwardedTraffic) +
    attributeIfTrue("allowGatewayTransit", allowGatewayTransit, allowGatewayTransit) +
    attributeIfTrue("useRemoteGateways", useRemoteGateways, useRemoteGateways) +
    attributeIfContent("remoteVirtualNetwork", remoteVirtualNetwork) +
    attributeIfContent("remoteAddressSpace", remoteAddressSpace) +
    attributeIfContent("peeringState", peeringState)
  ]
[/#function]
[#macro createVnetPeering
  name
  properties
  outputs={}
  dependsOn=[]]

  [@armResource
    name=name
    type="Microsoft.Network/virtualNetworks/virtualNetworkPeerings"
    apiVersion="2019-02-01"
    properties=properties
    outputs=outputs
    dependsOn=dependsOn
  /]
[/#macro]

[#function getVNetDHCPOptions dnsServers=[]]

  [#local dhcpOptions = 
    {} +
    attributeIfContent("dnsServers", asArray(dnsServers))
  ]

  [#return 
    {} +
    attributeIfContent("dhcpOptions", dhcpOptions)
  ]
[/#function]
[#function getVNetAddressSpace addressSpacePrefixes=[]]

  [#local addressSpace =
    {} +
    attributeIfContent("addressPrefixes", asArray(addressSpacePrefixes))
  ]

  [#return
    {} +
    attributeIfContent("addressSpace", addressSpace)
  ]
[/#function]
[#macro createVNet
  name
  properties
  location=regionId
  outputs={}
  dependsOn=[]]

  [@armResource
    name=name
    type="Microsoft.Network/virtualNetworks"
    apiVersion="2019-02-01"
    properties=properties
    location=location
    outputs=outputs
    dependsOn=dependsOn
  /]
[/#macro]

[#-- TODO(rossmurr4y): Flow Logs object is not currently supported, though exists when created
via PowerShell. This is being developed by Microsoft and expected Jan 2020 - will need to revisit
this implimentation at that time to ensure this object remains correct.
https://feedback.azure.com/forums/217313-networking/suggestions/37713784-arm-template-support-for-nsg-flow-logs
 --]
[#function getFlowLogsObject
  targetResourceId
  storageId
  enabled
  targetResourceGuid=""
  workspaceId=""
  trafficAnalyticsInterval=""
  retentionPolicyEnabled=false
  retentionDays=""
  formatType=""
  formatVersion=""]

  [#if enabled]

    [#local networkWatcherFlowAnalyticsConfiguration =
      { "enabled" : true } +
      attributeIfContent("workspaceId", workspaceId) +
      attributeIfContent("trafficAnalyticsInterval", trafficAnalyticsInterval)
    ]

    [#local flowAnalyticsConfiguration =
      { 
        "networkWatcherFlowAnalyticsConfiguration" : networkWatcherFlowAnalyticsConfiguration
      }
    ]

    [#local retentionPolicy=
      {} +
      attributeIfContent("days", retentionDays) +
      attributeIfTrue("enabled", retentionPolicyEnabled, retentionPolicyEnabled)
    ]

    [#local format=
      {}+
      attributeIfContent("type", formatType) +
      attributeIfContent("version", formatVersion)
    ]

    [#return
      { "enabled" : enabled } +
      attributeIfContent("targetResourceId", getReference(targetResourceId)) +
      attributeIfContent("targetResourceGuid", targetResourceGuid) +
      attributeIfContent("storageId", storageId) +
      attributeIfContent("flowAnalyticsConfiguration", flowAnalyticsConfiguration) +
      attributeIfContent("retentionPolicy", retentionPolicy) +
      attributeIfContent("format", format)
    ]
  [#else]
    [#return {}]
  [/#if]

[/#function]
[#macro createNetworkWatcher
  name
  properties=
  location=""
  outputs={}
  dependsOn=[]]

  [@armResource
    name=name
    type="Microsoft.Network/networkWatchers"
    apiVersion="2019-04-01"
    properties=properties
    location=location
    outputs=outputs
    dependsOn=dependsOn
  /]
[/#macro]