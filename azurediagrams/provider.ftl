[#ftl]

[#--
    AZURE Supporting provider for the Diagrams Plugin https://github.com/hamlet-io/engine-plugin-diagrams
    Provides resource mappings for Azure resources
--]

[#assign AZUREDIAGRAMS_PROVIDER = "azurediagrams"]

[#-- Load all servicess --]
[@includeAllServicesConfiguration
    provider=AZURE_PROVIDER
/]

[@includeAllServicesConfiguration
    provider=AZUREDIAGRAMS_PROVIDER
/]
