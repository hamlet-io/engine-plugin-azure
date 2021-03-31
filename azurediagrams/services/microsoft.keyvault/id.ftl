[#ftl]

[#-- Service Mapping --]
[@addDiagramServiceMapping
    provider=AZURE_PROVIDER
    service=AZURE_KEYVAULT_SERVICE
    diagramsClass="diagrams.azure.security.KeyVaults"
/]

[#-- Resource Mappings --]
[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_KEYVAULT_SERVICE
    resourceType=AZURE_KEYVAULT_KEY_RESOURCE_TYPE
    diagramsClass="diagrams.azure.general.Subscriptions"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_KEYVAULT_SERVICE
    resourceType=LOCAL_SSH_PRIVATE_KEY_RESOURCE_TYPE
    diagramsClass="diagrams.azure.general.Subscriptions"
/]