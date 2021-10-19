[#ftl]

[#--
    Services are structured within the plugin by their top-level Azure Service Type.
    Where a large resource definition within a given Service warrants being split into
    several files for maintainability, dot-notation will be used.

    Format: service.resource.subresource

    ie. "microsoft.network.applicationgateways"
--]

[#-- Microsoft.AAD --]
[#assign AZURE_AAD_SERVICE = "microsoft.aad"]
[@addService provider=AZURE_PROVIDER service=AZURE_AAD_SERVICE /]

[#-- Microsoft.ApiManagement --]
[#assign AZURE_API_MANAGEMENT_SERVICE = "microsoft.apimanagement"]
[@addService provider=AZURE_PROVIDER service=AZURE_API_MANAGEMENT_SERVICE /]

[#-- Microsoft.Authorization --]
[#assign AZURE_AUTHORIZATION_SERVICE = "microsoft.authorization"]
[@addService provider=AZURE_PROVIDER service=AZURE_AUTHORIZATION_SERVICE /]

[#-- Microsoft.Compute --]
[#assign AZURE_VIRTUALMACHINE_SERVICE = "microsoft.compute"]
[@addService provider=AZURE_PROVIDER service=AZURE_VIRTUALMACHINE_SERVICE /]

[#-- Microsoft.ContainerService --]
[#assign AZURE_CONTAINER_SERVICE = "microsoft.containerservice"]
[@addService provider=AZURE_PROVIDER service=AZURE_CONTAINER_SERVICE /]

[#-- Microsoft.Insights --]
[#assign AZURE_INSIGHTS_SERVICE = "microsoft.insights"]
[@addService provider=AZURE_PROVIDER service=AZURE_INSIGHTS_SERVICE /]

[#-- Microsoft.KeyVault --]
[#assign AZURE_KEYVAULT_SERVICE = "microsoft.keyvault"]
[@addService provider=AZURE_PROVIDER service=AZURE_KEYVAULT_SERVICE /]

[#-- Microsoft.ManagedIdentity --]
[#assign AZURE_IAM_SERVICE = "microsoft.managedidentity"]
[@addService provider=AZURE_PROVIDER service=AZURE_IAM_SERVICE /]

[#-- Microsoft.Network --]
[#assign AZURE_NETWORK_SERVICE = "microsoft.network"]
[@addService provider=AZURE_PROVIDER service=AZURE_NETWORK_SERVICE /]
[#assign AZURE_NETWORK_APPLICATION_GATEWAY_SERVICE = "microsoft.network.applicationgateways"]
[@addService provider=AZURE_PROVIDER service=AZURE_NETWORK_APPLICATION_GATEWAY_SERVICE /]
[#assign AZURE_NETWORK_FRONTDOOR_SERVICE = "microsoft.network.frontdoor"]
[@addService provider=AZURE_PROVIDER service=AZURE_NETWORK_FRONTDOOR_SERVICE /]

[#-- Microsoft.DBforPostgreSQL --]
[#assign AZURE_DB_POSTGRES_SERVICE = "microsoft.dbforpostgresql"]
[@addService provider=AZURE_PROVIDER service=AZURE_DB_POSTGRES_SERVICE /]

[#-- Microsoft.DBforMySQL --]
[#assign AZURE_DB_MYSQL_SERVICE = "microsoft.dbformysql"]
[@addService provider=AZURE_PROVIDER service=AZURE_DB_MYSQL_SERVICE /]

[#-- Microsoft.Resources--]
[#assign AZURE_RESOURCES_SERVICE = "microsoft.resources"]
[@addService provider=AZURE_PROVIDER service=AZURE_RESOURCES_SERVICE /]

[#-- Microsoft.Storage --]
[#assign AZURE_STORAGE_SERVICE = "microsoft.storage"]
[@addService provider=AZURE_PROVIDER service=AZURE_STORAGE_SERVICE /]

[#-- Microsoft.Web --]
[#assign AZURE_WEB_SERVICE = "microsoft.web"]
[@addService provider=AZURE_PROVIDER service=AZURE_WEB_SERVICE /]

[#-- Pseudo services --]
[#assign AZURE_BASELINE_PSEUDO_SERVICE = "baseline"]
[@addService provider=AZURE_PROVIDER service=AZURE_BASELINE_PSEUDO_SERVICE /]
[#assign AZURE_AAD_APP_REGISTRATION_PSEUDO_SERVICE = "microsoft.aad.appregistration"]
[@addService provider=AZURE_PROVIDER service=AZURE_AAD_APP_REGISTRATION_PSEUDO_SERVICE /]
