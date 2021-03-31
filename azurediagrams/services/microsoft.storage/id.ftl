[#ftl]

[#-- Service Mapping --]
[@addDiagramServiceMapping
    provider=AZURE_PROVIDER
    service=AZURE_STORAGE_SERVICE
    diagramsClass="diagrams.azure.storage.GeneralStorage"
/]

[#-- Resource Mappings --]
[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_STORAGE_SERVICE
    resourceType=AZURE_STORAGEACCOUNT_RESOURCE_TYPE
    diagramsClass="diagrams.azure.storage.StorageAccounts"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_STORAGE_SERVICE
    resourceType=AZURE_BLOBSERVICE_RESOURCE_TYPE
    diagramsClass="diagrams.azure.storage.BlobStorage"
/]

[@addDiagramResourceMapping
    provider=AZURE_PROVIDER
    service=AZURE_STORAGE_SERVICE
    resourceType=AZURE_QUEUE_RESOURCE_TYPE
    diagramsClass="diagrams.azure.storage.QueuesStorage"
/]