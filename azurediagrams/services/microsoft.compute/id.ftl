[#ftl]

[#-- Service Mapping --]
[@addDiagramServiceMapping
    provider=AZURE_PROVIDER
    service=AZURE_VIRTUALMACHINE_SERVICE
    diagramsClass="diagrams.azure.compute.VM"
/]

[#-- Resource Mappings --]
[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_VIRTUALMACHINE_SERVICE
    resourceType=AZURE_VIRTUALMACHINE_SCALESET_RESOURCE_TYPE
    diagramsClass="diagrams.azure.compute.VMScaleSet"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_VIRTUALMACHINE_SERVICE
    resourceType=AZURE_VIRTUALMACHINE_SCALESET_EXTENSION_RESOURCE_TYPE
    diagramsClass="diagrams.programming.language.Bash"
/]