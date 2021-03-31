[#ftl]

[#-- Service Mapping --]
[@addDiagramServiceMapping
    provider=AZURE_PROVIDER
    service=AZURE_CONTAINER_SERVICE
    diagramsClass="diagrams.azure.compute.ContainerInstances"
/]

[#-- Resource Mappings --]
[#-- This is set in case the default changes or others are added over time --]
[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_CONTAINER_SERVICE
    resourceType=AZURE_CONTAINERS_CLUSTER_RESOURCE_TYPE
    diagramsClass="diagrams.azure.compute.ContainerInstances"
/]