[#ftl]

[#assign AZURE_PROVIDER = "azure"]

[#-- Deployment frameworks --]
[#assign AZURE_RESOURCE_MANAGER_DEPLOYMENT_FRAMEWORK = "arm"]
[#assign ARMSchemas = {
    "Template" : "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "Parameters" : "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#"
}]

[#-- Services that must always be available to the provider --]
[@includeServicesConfiguration
    provider=AZURE_PROVIDER
    deploymentFramework=AZURE_RESOURCE_MANAGER_DEPLOYMENT_FRAMEWORK
    services=[
        AZURE_RESOURCES_SERVICE
    ]
/]