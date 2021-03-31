[#ftl]

[#-- Service Mapping --]
[@addDiagramServiceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    diagramsClass="diagrams.azure.network.VirtualNetworks"
/]

[#-- Resource Mappings --]
[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_APPLICATION_SECURITY_GROUP_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.ApplicationSecurityGroups"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_NETWORK_INTERFACE_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.NetworkInterfaces"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.DNSPrivateZones"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_PUBLIC_IP_ADDRESS_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.PublicIpAddresses"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_ROUTE_TABLE_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.RouteTables"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_ROUTE_TABLE_ROUTE_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.RouteFilters"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_SERVICE_ENDPOINT_POLICY_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.ServiceEndpointPolicies"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_SUBNET_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.Subnets"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_VIRTUAL_NETWORK_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.VirtualNetworks"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.NetworkSecurityGroupsClassic"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_NETWORK_WATCHER_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.NetworkWatcher"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_SERVICE
    resourceType=AZURE_NETWORK_WATCHER_FLOWLOG_RESOURCE_TYPE
    diagramsClass="diagrams.azure.analytics.LogAnalyticsWorkspaces"
/]