[#ftl]

[#-- Service Mapping --]
[@addDiagramServiceMapping
    provider=AZURE_PROVIDER
    service=AZURE_WEB_SERVICE
    diagramsClass="diagrams.azure.web.AppServices"
/]

[#-- Resource Mappings --]
[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_WEB_SERVICE
    resourceType=AZURE_APP_SERVICE_PLAN_RESOURCE_TYPE
    diagramsClass="diagrams.azure.web.AppServicePlans"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_WEB_SERVICE
    resourceType=AZURE_WEB_APP_RESOURCE_TYPE
    diagramsClass="diagrams.azure.web.AppServiceDomains"
/]