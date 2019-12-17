[#ftl]

[#assign networkResourceProfiles = {
  AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE : {
    "apiVersion" : "2019-09-01",
    "type" : "Microsoft.Network/applicationGateways"
  },
  AZURE_APPLICATION_SECURITY_GROUP_RESOURCE_TYPE : {
    "apiVersion" : "2019-04-01",
    "type" : "Microsoft.Network/applicationSecurityGroups"
  },
  AZURE_ROUTE_TABLE_RESOURCE_TYPE : {
    "apiVersion" : "2019-02-01",
    "type" : "Microsoft.Network/routeTables"
  },
  AZURE_ROUTE_TABLE_ROUTE_RESOURCE_TYPE : {
    "apiVersion" : "2019-02-01",
    "type" : "Microsoft.Network/routeTables/routes"
  },
  AZURE_SERVICE_ENDPOINT_POLICY_RESOURCE_TYPE : {
    "apiVersion" : "2019-02-01",
    "type" : "Microsoft.Network/serviceEndpointPolicies"
  },
  AZURE_SERVICE_ENDPOINT_POLICY_DEFINITION_RESOURCE_TYPE : {
    "apiVersion" : "2019-02-01",
    "type" : "Microsoft.Network/serviceEndpointPolicies/serviceEndpointPolicyDefinitions"
  },
  AZURE_SUBNET_RESOURCE_TYPE : {
    "apiVersion" : "2019-02-01",
    "type" : "Microsoft.Network/virtualNetworks/subnets"
  },
  AZURE_VIRTUAL_NETWORK_RESOURCE_TYPE : {
    "apiVersion" : "2019-02-01",
    "type" : "Microsoft.Network/virtualNetworks"
  },
  AZURE_VIRTUAL_NETWORK_PEERING_RESOURCE_TYPE : {
    "apiVersion" : "2019-02-01",
    "type" : "Microsoft.Network/virtualNetworks/virtualNetworkPeerings"
  },
  AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE : {
    "apiVersion" : "2019-02-01",
    "type" : "Microsoft.Network/networkSecurityGroups"
  },
  AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE : {
    "apiVersion" : "2019-04-01",
    "type" : "Microsoft.Network/networkSecurityGroups/securityRules"
  },
  AZURE_NETWORK_WATCHER_RESOURCE_TYPE : {
    "apiVersion" : "2019-04-01",
    "type" : "Microsoft.Network/networkWatchers"
  },
  AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE : {
    "apiVersion" : "2018-09-01",
    "type" : "Microsoft.Network/privateDnsZones"
  },
  AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE : {
    "apiVersion" : "2018-09-01",
    "type" : "Microsoft.Network/privateDnsZones/virtualNetworkLinks"
  }
}]

[#list networkResourceProfiles as resource,attributes]
  [@addResourceProfile
    service=AZURE_NETWORK_SERVICE
    resource=resource
    profile=
      {
        "apiVersion" : attributes.apiVersion,
        "type" : attributes.type
      }
  /]
[/#list]

[@addOutputMapping 
  provider=AZURE_PROVIDER
  resourceType=AZURE_VIRTUAL_NETWORK_RESOURCE_TYPE
  mappings=
    {
      REFERENCE_ATTRIBUTE_TYPE : {
        "Property" : "id"
      }
    }
/]

[@addOutputMapping 
  provider=AZURE_PROVIDER
  resourceType=AZURE_SUBNET_RESOURCE_TYPE
  mappings=
    {
      REFERENCE_ATTRIBUTE_TYPE : {
        "Property" : "id"
      }
    }
/]

[@addOutputMapping
  provider=AZURE_PROVIDER
  resourceType=AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE
  mappings=
    {
      REFERENCE_ATTRIBUTE_TYPE : {
        "Property" : "id"
      }
    }
/]

[#macro createApplicationSecurityGroup id name location tags={}]
  [@armResource
    id=id
    name=name
    profile=AZURE_APPLICATION_SECURITY_GROUP_RESOURCE_TYPE
    location=location
    tags=tags
  /]
[/#macro]

[#macro createNetworkSecurityGroupSecurityRule
  id
  name
  nsgName
  access
  direction
  sourceAddressPrefix=""
  sourceAddressPrefixes=[]
  sourceApplicationSecurityGroups=[]
  destinationPortProfileName=""
  destinationAddressPrefix=""
  destinationAddressPrefixes=[]
  destinationApplicationSecurityGroups=[]
  description=""
  priority=4096
  tags={}
  outputs={}
  dependsOn=[]]

  [#local destinationPortProfile = ports[destinationPortProfileName]]
  [#if destinationPortProfileName == "any"]
    [#local destinationPort = "*"]
  [#else]
    [#local destinationPort = isPresent(destinationPortProfile.PortRange)?then(
      destinationPortProfile.PortRange.From + "-" + destinationPortProfile.PortRange.To,
      destinationPortProfile.Port)]
  [/#if]

  [#--
    Azure will generate alerts if you provide source-port range/s as port filtering is
    primarily on the destination. Their recommendation is to specify "any" ("*") port.
  --]
  [@armResource
    id=id
    name=name
    parentNames=[nsgName]
    profile=AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE
    dependsOn=dependsOn
    properties=  
      {
        "access" : access,
        "direction" : direction,
        "protocol" : destinationPortProfile.IPProtocol?replace("all", "*"),
        "sourcePortRange": "*"
      } +
      attributeIfContent("sourceAddressPrefix", formatAzureIPAddress(sourceAddressPrefix)) +
      attributeIfContent("sourceAddressPrefixes", formatAzureIPAddresses(sourceAddressPrefixes)) +
      attributeIfContent("sourceApplicationSecurityGroups", sourceApplicationSecurityGroups) +
      attributeIfContent("destinationPortRange", destinationPort) +
      attributeIfContent("destinationAddressPrefix", formatAzureIPAddress(destinationAddressPrefix)) +
      attributeIfContent("destinationAddressPrefixes", formatAzureIPAddresses(destinationAddressPrefixes)) +
      attributeIfContent("destinationApplicationSecurityGroups", destinationApplicationSecurityGroups) +
      attributeIfContent("description", description) +
      attributeIfContent("priority", priority)
    tags=tags
    outputs=outputs
  /]
  
[/#macro]

[#macro createRouteTableRoute
  id
  name
  nextHopType 
  addressPrefix="" 
  nextHopIpAddress=""
  dependsOn=[]
  outputs={}
  tags={}]

  [@armResource
    id=id
    name=name
    profile=AZURE_ROUTE_TABLE_ROUTE_RESOURCE_TYPE
    properties={ "nextHopType" : nextHopType } + 
      attributeIfContent("addressPrefix", addressPrefix) +
      attributeIfContent("nextHopIpAddress", nextHopIpAddress)
    dependsOn=dependsOn
    outputs=outputs
    tags=tags
  /]

[/#macro]

[#macro createRouteTable
  id
  name
  routes=[]
  disableBgpRoutePropagation=false
  location=""
  tags={}
  dependsOn=[]
  outputs={}]

  [@armResource
    id=id
    name=name
    profile=AZURE_ROUTE_TABLE_RESOURCE_TYPE
    location=location
    tags=tags
    properties={} +
      attributeIfContent("routes", routes) +
      attributeIfTrue("disableBgpRoutePropagation", disableBgpRoutePropagation, disableBgpRoutePropagation)
    dependsOn=dependsOn
    outputs=outputs
  /]

[/#macro]

[#macro createNetworkSecurityGroup
  id
  name
  location=""
  tags={}
  resources=[]
  dependsOn=[]
  outputs={}]

  [@armResource
    id=id
    name=name
    profile=AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE
    location=location
    tags=tags
    resources=resources
    dependsOn=dependsOn
    outputs=outputs
  /]
[/#macro]

[#macro createServiceEndpointPolicyDefinition
  id
  name
  description=""
  service=""
  serviceResources=[]
  dependsOn=[]
  outputs={}]

  [@armResource
    id=id
    name=name
    profile=AZURE_SERVICE_ENDPOINT_POLICY_DEFINITION_RESOURCE_TYPE
    properties={} +
      attributeIfContent("description", description) +
      attributeIfContent("service", service) +
      attributeIfContent("serviceResources", serviceResources)
    dependsOn=dependsOn
    outputs=outputs
  /]
[/#macro]

[#macro createServiceEndpointPolicy
  id
  name
  location=""
  dependsOn=[]
  tags={}]

  [@armResource 
    id=id
    name=name
    profile=AZURE_SERVICE_ENDPOINT_POLICY_RESOURCE_TYPE
    location=location
    dependsOn=dependsOn
    tags=tags
  /]
[/#macro]

[#function getSubnetDelegation
  id=""
  name=""
  serviceName=""
  actions=[]]

  [#local properties = {} +
    attributeIfContent("id", getReference(id)) +
    attributeIfContent("serviceName", serviceName) +
    attributeIfContent("actions", actions)
  ]

  [#return {} +
    attributeIfContent("id", id) + 
    attributeIfContent("name", name) +
    attributeIfContent("properties", properties)
  ]
[/#function]

[#function getSubnetLink
  id=""
  resourceName=""
  linkedResourceType=""
  resourceLink=""]

  [#local properties = {} +
    attributeIfContent("linkedResourceType", linkedResourceType) +
    attributeIfContent("link", resourceLink)
  ]

  [#return {} +
    attributeIfContent("id", getReference(id)) +
    attributeIfContent("name", getReference(resourceName)) +
    attributeIfContent("properties", properties)
  ]
[/#function]

[#function getSubnetServiceEndpoint
  serviceType=""
  locations=[]]

  [#return {} + 
    attributeIfContent("service", serviceType) +
    attributeIfContent("locations", locations)
  ]
[/#function]

[#macro createSubnet
  id
  name
  vnetName
  addressPrefix=""
  addressPrefixes=[]
  networkSecurityGroup={}
  routeTable={}
  natGatewayId=""
  serviceEndpoints=[]
  serviceEndpointPolicies=[]
  resourceNavigationLinks=[]
  serviceAssociationLinks=[]
  delegations=[]
  dependsOn=[]]

  [@armResource
    id=id
    name=name
    parentNames=[vnetName]
    profile=AZURE_SUBNET_RESOURCE_TYPE
    properties={} +
      attributeIfContent("addressPrefix", addressPrefix) +
      attributeIfContent("addressPrefixes", addressPrefixes) +
      attributeIfContent("networkSecurityGroup", networkSecurityGroup) +
      attributeIfContent("routeTable", routeTable) +
      attributeIfContent("natGateway", attributeIfContent("id", natGatewayId)) +
      attributeIfContent("serviceEndpoints", serviceEndpoints) +
      attributeIfContent("serviceEndpointPolicies", serviceEndpointPolicies) +
      attributeIfContent("resourceNavigationLinks", resourceNavigationLinks) +
      attributeIfContent("serviceAssociationLinks", serviceAssociationLinks) +
      attributeIfContent("delegations", delegations)
    dependsOn=dependsOn
  /]
[/#macro]

[#macro createVnetPeering
  id
  name
  allowVNetAccess=false
  allowForwardedTraffic=false
  allowGatewayTransit=false
  useRemoteGateways=false
  remoteVirtualNetworkId=""
  remoteAddressSpacePrefixes=[]
  peeringState=""
  outputs={}
  dependsOn=[]]

  [@armResource
    id=id
    name=name
    profile=AZURE_VIRTUAL_NETWORK_PEERING_RESOURCE_TYPE
    properties={} +
      attributeIfTrue("allowVNetAccess", allowVNetAccess, allowVNetAccess) +
      attributeIfTrue("allowForwardedTraffic", allowForwardedTraffic, allowForwardedTraffic) +
      attributeIfTrue("allowGatewayTransit", allowGatewayTransit, allowGatewayTransit) +
      attributeIfTrue("useRemoteGateways", useRemoteGateways, useRemoteGateways) +
      attributeIfContent("remoteVirtualNetwork", { "id" : remoteVirtualNetworkId } ) +
      attributeIfContent("remoteAddressSpace", { "addressPrefixes" : remoteAddressSpacePrefixes } ) +
      attributeIfContent("peeringState", peeringState)
    outputs=outputs
    dependsOn=dependsOn
  /]
[/#macro]

[#macro createVNet
  id
  name
  dnsServers=[]
  addressSpacePrefixes=[]
  location=regionId
  outputs={}
  dependsOn=[]]

  [@armResource
    id=id
    name=name
    profile=AZURE_VIRTUAL_NETWORK_RESOURCE_TYPE
    location=location
    outputs=outputs
    dependsOn=dependsOn
    properties={} +
      attributeIfContent("addressSpace", {} + 
        attributeIfContent("addressPrefixes", addressSpacePrefixes)
      ) +
      attributeIfContent("dhcpOptions", {} +
        attributeIfContent("dnsServers", dnsServers)
      )
  /]
[/#macro]

[#-- 
  TODO(rossmurr4y): Flow Logs object is not currently supported, though exists when created
  via PowerShell. This is being developed by Microsoft and expected Jan 2020 - will need to revisit
  this implimentation at that time to ensure this object remains correct.
  https://feedback.azure.com/forums/217313-networking/suggestions/37713784-arm-template-support-for-nsg-flow-logs
--]
[#macro createNetworkWatcherFlowLog
  id
  name
  targetResourceId
  storageId
  targetResourceGuid=""
  workspaceId=""
  trafficAnalyticsInterval=""
  retentionPolicyEnabled=false
  retentionDays=""
  formatType=""
  formatVersion=""
  location=""
  outputs={}
  dependsOn=[]]

  [#local networkWatcherFlowAnalyticsConfiguration = { "enabled" : true } +
    attributeIfContent("workspaceId", workspaceId) +
    attributeIfContent("trafficAnalyticsInterval", trafficAnalyticsInterval)]

  [#local flowAnalyticsConfiguration = { "networkWatcherFlowAnalyticsConfiguration" : networkWatcherFlowAnalyticsConfiguration }]

  [#local retentionPolicy = {} +
    attributeIfContent("days", retentionDays) +
    attributeIfTrue("enabled", retentionPolicyEnabled, retentionPolicyEnabled)]

  [#local format = {} +
    attributeIfContent("type", formatType) +
    attributeIfContent("version", formatVersion)]

  [@armResource
    id=id
    name=name
    profile=AZURE_NETWORK_WATCHER_RESOURCE_TYPE
    properties={ "enabled" : true } +
      attributeIfContent("targetResourceId", getReference(targetResourceId)) +
      attributeIfContent("targetResourceGuid", targetResourceGuid) +
      attributeIfContent("storageId", storageId) +
      attributeIfContent("flowAnalyticsConfiguration", flowAnalyticsConfiguration) +
      attributeIfContent("retentionPolicy", retentionPolicy) +
      attributeIfContent("format", format)
    location=location
    outputs=outputs
    dependsOn=dependsOn
  /]
[/#macro]

[#macro createPrivateDnsZone
  id
  name]
  
  [@armResource
    id=id
    name=name
    profile=AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE
    location="global"
    properties={}
  /]
[/#macro]

[#macro createPrivateDnsZoneVnetLink
  id
  name
  vnetId
  autoRegistrationEnabled=false]

  [@armResource
    id=id
    name=name
    profile=AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE
    location="global"
    properties=
      {
        "virtualNetwork" : {
          "id" : vnetId
        } +
        attributeIfTrue(
          "registrationEnabled",
          autoRegistrationEnabled,
          autoRegistrationEnabled
        )
      }
  /]

[/#macro]

[#function getAppGatewayIPConfiguration name subnetId]
  [#return {
      "name": name,
      "properties" : {
        "subnet" : getSubResourceReference(subnetId)
      }
  }]
[/#function]

[#function getAppGatewayAuthenticationCertificate name data]
  [#return {
    "name": name,
    "properties" : { "data" : data }
  }]
[/#function]

[#function getAppGatewayTrustedRootCertificate name data="" secretId=""]
  [#return {
      "name": name,
      "properties" : {} +
        attributeIfContent("data", data) +
        attributeIfContent("keyVaultSecretId", secretId)
  }]
[/#function]

[#function getAppGatewaySslCertificate
  name 
  data=""
  dataPwd=""
  publicCertData=""
  keyVaultSecretId=""]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfContent("data", data) +
        attributeIfContent("password", dataPwd) +
        attributeIfContent("publicCertData", publicCertData) +
        attributeIfContent("keyVaultSecretId", keyVaultSecretId)
    }
  ]
[/#function]

[#function getAppGatewayFrontendIPConfiguration
  name
  privateIpAddress=""
  privateIpAllocationMethod="Static"
  subnetId=""
  publicIpAddressId=""]

  [#return
    {
      "name": name,
      "properties" : {
        "privateIPAllocationMethod": privateIpAllocationMethod
      } +
        attributeIfContent("privateIPAddress", privateIpAddress) +
        attributeIfContent("subnet",
          getSubResourceReference(subnetId)) +
        attributeIfContent("publicIPAddress",
          getSubResourceReference(publicIpAddressId))
    }
  ]
[/#function]

[#function getAppGatewayFrontendPort name port]
  [#return
    {
      "name" : name,
      "properties": { "port" : port }
    }
  ]
[/#function]

[#function getAppGatewayProbe
  name
  protocol=""
  host=""
  path=""
  interval=""
  timeout=""
  unhealthyThreshold=""
  pickHostNameFromBackendHttpSettings=false
  minServers=""
  matchBody=""
  matchStatusCodes=[]
  port=""]
  [#return
    {
      "name" : name,
      "properties" : {} +
        attributeIfContent("protocol", protocol) +
        attributeIfContent("host", host) +
        attributeIfContent("path", path) +
        attributeIfContent("interval", interval) +
        attributeIfContent("timeout", timeout) +
        attributeIfContent("unhealthyThreshold", unhealthyThreshold) +
        attributeIfTrue("pickHostNameFromBackendHttpSettings",
          pickHostNameFromBackendHttpSettings,
          pickHostNameFromBackendHttpSettings) +
        attributeIfContent("minServers", minServers) +
        attributeIfContent("match", 
          attributeIfContent("body", matchBody) + 
          attributeIfContent("statusCodes", matchStatusCodes)) +
        attributeIfContent("port", port)
    }
  ]
[/#function]

[#function getAppGatewayBackendAddressPool
  name
  ipConfigurations=[]
  backendAddresses=[]]

  [#local backendIpAddresses = []]
  [#list backendAddresses as ipAddress]
    [#local backendIpAddresses += [{"ipAddress": ipAddress}]]
  [/#list]

  [#return
    {
      "name" : name,
      "properties" : {} +
        attributeIfContent("backendIPConfigurations", ipConfigurations) +
        attributeIfContent("backendAddresses", backendIpAddresses)
    }
  ]
[/#function]

[#function getAppGatewayBackendHttpSettingsCollection
  name
  port=""
  cookieBasedAffinity=false
  requestTimeout=""
  probeId=""
  authenticationCertificates=[]
  trustedRootCertificates=[]
  connectionDrainingEnabled=false
  connectionDrainingTimeoutInSec=""
  hostName=""
  pickHostNameFromBackendAddress=false
  affinityCookieName=""
  probeEnabled=false
  path=""]

  [#local connectionDraining = {} +
    attributeIfTrue("enabled",
      connectionDrainingEnabled,
      connectionDrainingEnabled) + 
    attributeIfTrue("drainTimeoutInSec",
      connectionDrainingEnabled,
      connectionDrainingTimeoutInSec)]

  [#return
    {
      "name" : name,
      "properties": {} +
        attributeIfContent("port", port) +
        attributeIfContent("protocol", protocol) +
        attributeIfTrue("cookieBasedAffinity", cookieBasedAffinity, "Enabled") +
        attributeIfContent("requestTimeout", requestTimeout) +
        attributeIfContent("probe", 
          getSubResourceReference(probeId)) +
        attributeIfContent("authenticationCertificates", authenticationCertificates) +
        attributeIfContent("trustedRootCertificates", trustedRootCertificates) +
        attributeIfContent("connectionDraining", connectionDraining) +
        attributeIfContent("hostName", hostName) +
        attributeIfTrue("pickHostNameFromBackendAddress",
          pickHostNameFromBackendAddress,
          pickHostNameFromBackendAddress) +
        attributeIfContent("affinityCookieName", affinityCookieName) +
        attributeIfTrue("probeEnabled", probeEnabled, probeEnabled) +
        attributeIfContent("path", path)
    }
  ]
[/#function]

[#function getAppGatewayHttpListener
  name
  frontendIPConfigurationId=""
  frontendPortId=""
  protocol=""
  hostName=""
  sslCertificateId=""
  requireServerNameIndication=false
  customErrorConfigurations=[]]

  [#-- applicable only to https --]
  [#local serverNameIndication = ""]
  [#if protocol?lower_case == "https"]
    [#local serverNameIndication = requireServerNameIndication]
  [/#if]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfContent("frontendIPConfiguration", 
          getSubResourceReference(frontendIPConfigurationId)) +
        attributeIfContent("frontendPort", 
          getSubResourceReference(frontendPortId)) +
        attributeIfContent("protocol", protocol) +
        attributeIfContent("hostName", hostName) +
        attributeIfContent("sslCertificate", 
          getSubResourceReference(sslCertificateId)) +
        attributeIfContent("requireServerNameIndication", serverNameIndication) +
        attributeIfContent("customErrorConfigurations", customErrorConfigurations)
    }
  ]
[/#function]

[#function getAppGatewayPathRules
  name
  paths=[]
  backendAddressPoolId=""
  backendHttpSettingsId=""
  redirectConfigurationId=""
  rewriteRuleSetId=""]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfContent("paths", paths) +
        attributeIfContent("backendAddressPool",
          getSubResourceReference(backendAddressPoolId)) +
        attributeIfContent("backendHttpSettings",
          getSubResourceReference(backendHttpSettingsId)) +
        attributeIfContent("redirectConfiguration",
          getSubResourceReference(redirectConfigurationId)) +
        attributeIfContent("rewriteRuleSet",
          getSubResourceReference(rewriteRuleSetId))
    }
  ]
[/#function]

[#function getAppGatewayUrlPathMap
  name
  defaultBackendAddressPoolId={}
  defaultBackendHttpSettingsId={}
  defaultRewriteRulesetId={}
  defaultRedirectConfigurationId={}
  pathrules=[]]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfContent("defaultBackendAddressPool", 
          getSubResourceReference(defaultBackendAddressPoolId)) +
        attributeIfContent("defaultBackendHttpSettings", 
          getSubResourceReference(defaultBackendHttpSettingsId)) +
        attributeIfContent("defaultRewriteRuleSet", 
          getSubResourceReference(defaultRewriteRulesetId)) +
        attributeIfContent("defaultRedirectConfiguration",
          getSubResourceReference(defaultRedirectConfigurationId)) +
        attributeIfContent("pathRules", pathrules)       
    }
  ]
[/#function]

[#function getAppGatewayRequestRoutingRule
  name
  ruleType=""
  priority=""
  backendAddressPoolId=""
  backendHttpSettingsId=""
  httpListenerId=""
  urlPathMapId=""
  rewriteRuleSetId=""
  redirectConfigurationId=""]

  [#return
    {
      "name": name,
      "properties": {} +
        attributeIfContent("ruleType", ruleType) +
        attributeIfContent("priority", priority) +
        attributeIfContent("backendAddressPool",
          getSubResourceReference(backendAddressPoolId)) +
        attributeIfContent("backendHttpSettings",
          getSubResourceReference(backendHttpSettingsId)) +
        attributeIfContent("httpListener",
          getSubResourceReference(httpListenerId)) +
        attributeIfContent("urlPathMap",
          getSubResourceReference(urlPathMapId)) +
        attributeIfContent("rewriteRuleSet",
          getSubResourceReference(rewriteRuleSetId)) +
        attributeIfContent("redirectConfiguration",
          getSubResourceReference(redirectConfigurationId))
    }
  ]
[/#function]

[#function getAppGatewayRewriteRuleCondition
  variable=""
  pattern=""
  ignoreCase=false
  negate=false]

  [#return {} +
    attributeIfContent("variable", variable) +
    attributeIfContent("pattern", pattern) +
    attributeIfTrue("ignoreCase", ignoreCase, ignoreCase) +
    attributeIfTrue("negate", negate, negate)
  ]
[/#function]

[#function getAppGatewayRewriteRules
  name=""
  ruleSequence=""
  rewriteRuleConditions=[]
  requestHeaderConfigurations=[]
  responseHeaderConfigurations=[]]

  [#return {} +
    attributeIfContent("name", name) +
    attributeIfContent("ruleSequence", ruleSequence) +
    attributeIfContent("conditions", rewriteRuleConditions) +
    attributeIfContent("actionSet",
      attributeIfContent("requestHeaderConfigurations", requestHeaderConfigurations) +
      attributeIfContent("responseHeaderConfigurations", responseHeaderConfigurations))
  ]

[/#function]

[#function getAppGatewayRewriteRuleSet
  name
  rewriteRules=[]]

  [#return
    {
      "name" : name,
      "properties": {
        "rewriteRules" : rewriteRules
      }
    }
  ]
[/#function]

[#function getAppGatewayRedirectConfiguration
  name
  redirectType=""
  targetListenerId=""
  targetUrl=""
  includePath=false
  includeQueryString=false
  requestRoutingRuleIds=[]
  urlPathMapIds=[]
  pathRuleIds=[]]

  [#return
    {
      "name": name,
      "properties": {} +
        attributeIfContent("redirectType", redirectType) +
        attributeIfContent("targetListener",
          getSubResourceReferences(targetListenerId)) +
        attributeIfContent("targetUrl", targetUrl) +
        attributeIfTrue("includePath", includePath, includePath) +
        attributeIfTrue("includeQueryString", includeQueryString, includeQueryString) +
        attributeIfContent("requestRoutingRules",
          getSubResourceReferences(requestRoutingRuleIds)) +
        attributeIfContent("urlPathMaps",
          getSubResourceReferences(urlPathMapIds)) +
        attributeIfContent("pathRules",
          getSubResourceReferences(pathRuleIds))
    }
  ]
[/#function] 

[#function getAppGatewayCustomErrorConfiguration
  statusCode=""
  url=""]

  [#return
    {
      "statusCode": statusCode,
      "customErrorPageUrl": url
    }
  ]
[/#function]

[#macro createApplicationGateway
  id
  name
  location
  skuName=""
  skuTier=""
  skuCapacity=""
  sslPolicyDisabledProtocols=[]
  sslPolicyType=""
  sslPolicyName=""
  sslPolicyCipherSuites=[]
  sslPolicyMinProtocolVersion=""
  gatewayIPConfigurations=[]
  authenticationCertificates=[]
  trustedRootCertificates=[]
  sslCertificates=[]
  frontendIPConfigurations=[]
  frontendPorts=[]
  probes=[]
  backendAddressPools=[]
  backendHttpSettingsCollection=[]
  httpListeners=[]
  urlPathMaps=[]
  requestRoutingRules=[]
  rewriteRuleSets=[]
  redirectConfigurations=[]
  customErrorConfigurations=[]
  wafEnabled=false
  wafMode=""
  wafRuleSetType=""
  wafRuleSetVersion=""
  wafDisabledRuleGroups=[]
  wafRequestBodyCheck=false
  wafMaxRequestBodySizeInKb=""
  wafFileUploadLimitInMb=""
  wafExclusions=[]
  firewallPolicyId=""
  enableHttp2=false
  enableFips=false
  autoScaleMinCapacity=""
  autoScaleMaxCapacity=""
  identity={}
  outputs={}
  dependsOn=[]]

  [#local sku = {} +
    attributeIfContent("name", skuName) +
    attributeIfContent("tier", skuTier) +
    attributeIfContent("capacity", skuCapacity)]

  [#local sslPolicy = {} +
    attributeIfContent("disabledSslProtocols", sslPolicyDisabledProtocols) +
    attributeIfContent("policyType", sslPolicyType) +
    attributeIfContent("policyName", sslPolicyName) +
    attributeIfContent("cipherSuites", sslPolicyCipherSuites) +
    attributeIfContent("minProtocolVersion", sslPolicyMinProtocolVersion)]

  [#local wafConfiguration = {}]
  [#if wafEnabled]
    [#local wafConfiguration += {
      "enabled": wafEnabled,
      "firewallMode": wafMode,
      "ruleSetType": wafRuleSetType,
      "ruleSetVersion": wafRuleSetVersion
    } +
    attributeIfContent("disabledRuleGroups", wafDisabledRuleGroups) +
    attributeIfTrue("requestBodyCheck", wafRequestBodyCheck, wafRequestBodyCheck) +
    attributeIfContent("maxRequestBodySizeInKb", wafMaxRequestBodySizeInKb) +
    attributeIfContent("fileUploadLimitInMb", wafFileUploadLimitInMb) +
    attributeIfContent("exclusions", wafExclusions)]
  [/#if]

  [@armResource
    id=id
    name=name
    profile=AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE
    location=location
    identity=identity
    properties=
      {} +
      attributeIfContent("sku", sku) +
      attributeIfContent("sslPolicy", sslPolicy) +
      attributeIfContent("gatewayIPConfigurations", gatewayIPConfigurations) +
      attributeIfContent("authenticationCertificates", authenticationCertificates) +
      attributeIfContent("trustedRootCertificates", trustedRootCertificates) +
      attributeIfContent("sslCertificates", sslCertificates) +
      attributeIfContent("frontendIPConfigurations", frontendIPConfigurations) +
      attributeIfContent("frontendPorts", frontendPorts) +
      attributeIfContent("probes", probes) +
      attributeIfContent("backendAddressPools", backendAddressPools) +
      attributeIfContent("backendHttpSettingsCollection", backendHttpSettingsCollection) +
      attributeIfContent("httpListeners", httpListeners) +
      attributeIfContent("urlPathMaps", urlPathMaps) +
      attributeIfContent("requestRoutingRules", requestRoutingRules) +
      attributeIfContent("rewriteRuleSets", rewriteRuleSets) +
      attributeIfContent("redirectConfigurations", redirectConfigurations) +
      attributeIfContent("webApplicationFirewallConfiguration", wafConfiguration) +
      attributeIfContent("firewallPolicy", getSubResourceReference(firewallPolicyId)) +
      attributeIfTrue("enableHttp2", enableHttp2, enableHttp2) +
      attributeIfTrue("enableFips", enableFips, enableFips) +
      attributeIfContent("autoscaleConfiguration", {} +
        attributeIfTrue("minCapacity", autoScaleMinCapacity) +
        attributeIfTrue("maxCapacity", autoScaleMaxCapacity)) +
      attributeIfContent("customErrorConfigurations", customErrorConfigurations)
    outputs=outputs
    dependsOn=dependsOn
  /]

[/#macro]

[#-- 
  The nicConfigurationReference & getIPConfigurationReference objects allow for the reference to an
  existing NIC resource. It is not intended for use during the creation of a NIC.
--]
[#function getIPConfigurationReference
  publicIPId
  publicIPName
  subnetId]

  [#return
    {
      "id" : publicIPId,
      "name" : publicIPName,
      "properties" : {
        "subnet" : {
          "id" : subnetId
        }
      }
    }
  ]

[/#function]

[#function getNICConfigurationReference
  nicId
  nicName
  ipConfigurations=[]
  primary=true]

  [#return
    {
      "id" : nicId,
      "name" : nicName,
      "properties" : {
        "primary" : primary,
        "ipConfigurations" : ipConfigurations
      }
    }
  ]

[/#function]