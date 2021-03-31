[#ftl]

[#-- Service Mapping --]
[@addDiagramServiceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_FRONTDOOR_SERVICE
    diagramsClass="diagrams.azure.network.FrontDoors"
/]

[#-- Resource Mappings --]
[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_NETWORK_FRONTDOOR_SERVICE
    resourceType=AZURE_FRONTDOOR_WAF_POLICY_RESOURCE_TYPE
    diagramsClass="diagrams.azure.network.Firewall"
/]