[#ftl]

[#macro azure_apigateway_arm_generationcontract_application occurrence]
    [@addDefaultGenerationContract subsets=["pregeneration", "template"] /]
[/#macro]

[#macro azure_apigateway_arm_setup_application occurrence]

    [@debug message="Entering" context=occurrence enabled=true /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]
    [#local attributes = occurrence.State.Attributes]
    [#local publishers = attributes["PUBLISHERS"]]
    [#local buildSettings = occurrence.Configuration.Settings.Build]
    [#local buildRegistry = buildSettings["BUILD_FORMATS"].Value[0]]

    [#-- resources --]
    [#local service = resources["service"]]
    [#local authorizationserver = resources["authorizationserver"]]
    [#local identityprovider = resources["identityprovider"]]
    [#local product = resources["product"]]
    [#local apis = product.apis]

    [#-- Retrieve the OpenApi Spec from the registry --]
    [#-- and write it out to definition.json         --]
    [#if deploymentSubsetRequired("pregeneration", false)]
        [@addToDefaultBashScriptOutput
            content=
                getBuildScript(
                    "openapiFiles",
                    buildRegistry,
                    productName,
                    occurrence,
                    buildRegistry + ".zip"
                ) +
                [
                    "get_openapi_definition_file" + " " +
                            "\"" + buildRegistry + "\"" + " " +
                            "\"$\{openapiFiles[0]}\"" + " " +
                            "\"" + core.Id + "\"" + " " +
                            "\"" + core.Name + "\"" + " " +
                            "\"" + accountId + "\"" + " " +
                            "\"" + accountObject.AzureId + "\"" + " " +
                            "\"" + region + "\"" + " || return $?",
                    "#"
                ]
        /]
    [/#if]

    [#-- Get the definition that was        --]
    [#-- created/updated in "pregeneration" --]
    [#local apiManagementServicePublisher = {}]
    [#if definitionsObject[core.Id]??]

        [#local openapiDefinition = definitionsObject[core.Id]]
        [#local openapiDefinitionPublisherContact = openapiDefinition.info.contact!{}]

        [#-- Merge any definition contact info into the publisher object --]
        [#local apiManagementServicePublisher =
            mergeObjects(
                apiManagementServicePublisher,
                openapiDefinitionPublisherContact
            )
        ]

        [#-- check for openapi extensions - only 2 are supported 
        [#if getObjectAttributes(openapiDefinition, )]

        [/#if]--]

    [/#if]

    [#local openapiFileName = "openapi_" + commandLineOptions.Run.Id + ".json"]
    [#local openapiContainerName = ""]

    [#-- APIs --]
    [#local productDependencies = []]
    [#list apis as apiId, apiResources]

        [#-- merge CMDB publisher contact over existing any existing details --]
        [#if publishers[apiId].Enabled!false]
            [#local apiManagementServicePublisher =
                mergeObjects(
                    apiManagementServicePublisher,
                    publishers[apiId]
                )
            ]
        [/#if]
        
        [#local api = apiResources["api"]]
        [#local schema = apiResources["schema"]]

        [@createApiManagementServiceApi
            id=api.Id
            name=api.Name
            path="test"
            dependsOn=[service.Reference]
        /]

        [@createApiManagementServiceApiSchema
            id=schema.Id
            name=schema.Name
            contentType="application/vnd.oai.openapi.components+json"
            dependsOn=[api.Reference]
        /]

        [#local productDependencies += [api.Reference]]

    [/#list]

    [@createApiManagementServiceProduct
        id=product.Id
        name=product.Name
        dependsOn=productDependencies
    /]

    [#-- API Management Service --]
    [@createApiManagementService
        id=service.Id
        name=service.Name
        location=regionId
        skuName="Consumption"
        publisherEmail=apiManagementServicePublisher.Email
        publisherName=apiManagementServicePublisher.Name
    /]

    [#--
    [@createApiManagementServiceAuthorizationServer
        id=authorizationserver.Id
        name=authorizationserver.Name
        clientRegistrationEndpoint=
        authorizationEndpoint=
        grantTypes=
        clientId=
        dependsOn=[service.Reference]
    /]

    [@createApiManagementServiceIdentityProvider
        id=identityprovider.Id
        name=identityprovider.Name
        clientId=
        clientSecret=
        dependsOn=[service.Reference]
    /]--]

[/#macro]