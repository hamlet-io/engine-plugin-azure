[#ftl]

[#assign AZURE_APPLICATION_SECURITY_GROUP_RESOURCE_TYPE = "asg"]
[#assign AZURE_CONNECTION_RESOURCE_TYPE = "connection"]
[#assign AZURE_LOCAL_NETWORK_GATEWAY_RESOURCE_TYPE = "localNetworkGW"]
[#assign AZURE_NETWORK_INTERFACE_RESOURCE_TYPE = "nic"]
[#assign AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE = "privateDns"]
[#assign AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE = "vnetLink"]
[#assign AZURE_PUBLIC_IP_ADDRESS_PREFIX_RESOURCE_TYPE = "prefix"]
[#assign AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE = "publicIP"]
[#assign AZURE_ROUTE_TABLE_RESOURCE_TYPE = "routeTable"]
[#assign AZURE_ROUTE_TABLE_ROUTE_RESOURCE_TYPE = "route"]
[#assign AZURE_SERVICE_ENDPOINT_POLICY_RESOURCE_TYPE = "sep"]
[#assign AZURE_SERVICE_ENDPOINT_POLICY_DEFINITION_RESOURCE_TYPE = "sepDef"]
[#assign AZURE_SUBNET_RESOURCE_TYPE = "subnets"]
[#assign AZURE_VIRTUAL_NETWORK_RESOURCE_TYPE = "vnet"]
[#assign AZURE_VIRTUAL_NETWORK_GATEWAY_RESOURCE_TYPE = "virtualNetworkGW"]
[#assign AZURE_VIRTUAL_NETWORK_PEERING_RESOURCE_TYPE = "vnetPeering"]
[#assign AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE = "nsg"]
[#assign AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE = "rule"]
[#assign AZURE_NETWORK_WATCHER_RESOURCE_TYPE = "watcher"]
[#assign AZURE_NETWORK_WATCHER_FLOWLOG_RESOURCE_TYPE = "flowlog"]

[#function formatDependentNetworkWatcherId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_NETWORK_WATCHER_RESOURCE_TYPE
    resourceId,
    extensions)]
[/#function]

[#function formatDependentApplicationSecurityGroupId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_APPLICATION_SECURITY_GROUP_RESOURCE_TYPE
    resourceId,
    extensions)]
[/#function]

[#function formatDependentRouteTableId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_ROUTE_TABLE_RESOURCE_TYPE,
    resourceId,
    extensions)]
[/#function]
[#function formatDependentRouteTableRouteId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_ROUTE_TABLE_ROUTE_RESOURCE_TYPE,
    resourceId,
    extensions)]
[/#function]

[#function formatDependentServiceEndpointPolicyId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_SERVICE_ENDPOINT_POLICY_RESOURCE_TYPE,
    resourceId,
    extensions)]
[/#function]

[#function formatDependentServiceEndpointPolicyDefinitionId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_SERVICE_ENDPOINT_POLICY_DEFINITION_RESOURCE_TYPE,
    resourceId,
    extensions)]
[/#function]

[#function formatDependentSubnetId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_SUBNET_RESOURCE_TYPE,
    resourceId,
    extensions)]
[/#function]

[#function formatVirtualNetworkId ids...]
  [#return formatResourceId(
    AZURE_VIRTUAL_NETWORK_RESOURCE_TYPE,
    ids)]
[/#function]

[#function formatDependentVirtualNetworkPeeringId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_VIRTUAL_NETWORK_PEERING_RESOURCE_TYPE,
    resourceId,
    extensions)]
[/#function]

[#function formatDependentNetworkSecurityGroupId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE,
    resourceId,
    extensions)]
[/#function]

[#function formatNetworkSecurityGroupId ids...]
  [#return formatResourceId(
    AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE,
    ids)]
[/#function]

[#function formatDependentSecurityRuleId resourceId extensions...]
  [#return formatDependentResourceId(
    AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_SECURITY_RULE_RESOURCE_TYPE,
    resourceId,
    extensions)]
[/#function]
