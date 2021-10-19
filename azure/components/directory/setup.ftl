[#ftl]
[#macro azure_directory_arm_deployment_generationcontract occurrence ]
    [@addDefaultGenerationContract subsets=[ "template" ] /]
[/#macro]

[#macro azure_directory_arm_deployment occurrence ]
    [@debug message="Entering" context=occurrence enabled=false /]

    [@debug message="Entering Bastion Setup" context=occurrence enabled=false /]
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#-- Resources --]
    [#local directory = resources['directory']]

     [#local sku = getSkuProfile(occurrence, core.Type)]

    [#-- Network Lookups & Links --]
    [#-- As full subnet name is vnet/subnet, retrieve both & format --]
    [#local occurrenceNetwork = getOccurrenceNetwork(occurrence)]
    [#local networkLink = occurrenceNetwork.Link!{} ]
    [#local networkLinkTarget = getLinkTarget(occurrence, networkLink, false) ]

    [#if ! networkLinkTarget?has_content ]
        [@fatal message="Network could not be found" context=networkLink /]
        [#return]
    [/#if]

    [#local networkResources = networkLinkTarget.State.Resources ]
    [#local networkVnetResource = networkResources["vnet"]]
    [#local subnetResource = getSubnet(core.Tier, networkResources)]
    [#local subnetName = formatAzureResourceName(
        subnetResource.Name,
        getResourceType(subnetResource.Id),
        networkVnetResource.Name
    )]
    [#local subnetReference = getReference(subnetResource.Id)]

    [#if deploymentSubsetRequired(DIRECTORY_COMPONENT_TYPE, true)]
        [@createAzAzureAdDirectoryService
            id=directory.Id
            name=directory.Name
            location=getRegion()
            sku=sku.Name
            domainConfigurationType="FullySynced"
            domainName=directory.DomainName
            filteredSync="Disabled"
            subnetReferences=[
                subnetReference
            ]
        /]
    [/#if]

[/#macro]
