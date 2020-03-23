[#ftl]

[#macro azure_apigateway_arm_generationcontract_application occurrence]
    [@addDefaultGenerationContract subsets=["pregeneration", "parameters", "template"] /]
[/#macro]

[#macro azure_apigateway_arm_setup_application occurrence]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]
    [#local attributes = occurrence.State.Attributes]
    [#local buildSettings = occurrence.Configuration.Settings.Build]
    [#local buildRegistry = buildSettings["BUILD_FORMATS"].Value[0]]

    [#-- resources --]
    [#local service          = resources["service"]]
    [#local auth             = resources["authorizationserver"]]
    [#local identityprovider = resources["identityprovider"]]
    [#local product          = resources["product"]]
    [#local api              = resources["api"]]
    [#local schema           = resources["schema"]]

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
    [#local contact = {}]
    [#if definitionsObject[core.Id]??]

        [#local definition = definitionsObject[core.Id]]
        [#local openapiFileName = "openapi_" + commandLineOptions.Run.Id + ".json"]

        [#-- API Management contact details. CMDB > openapi spec. --]
        [#if definition.info?has_content]
            [#if definition.info.contact?has_content]
                [#local contact = mergeObjects(
                    contact,
                    {
                        "Name" : definition.info.contact.name!"",
                        "Email" : definition.info.contact.email!""
                    }
                )]
            [/#if]
        [/#if]
        [#local contact = mergeObjects(
            contact,
            {} +
            attributeIfContent("Name", solution["azure:Contact"].Name!"") +
            attributeIfContent("Email", solution["azure:Contact"].Email!"")
        )]

        [#-- Link to externalservice & retrieve App Registration Client Id --]
        [#-- this should be performed via an adaptor component             --]
        [#local links = getLinkTargets(occurrence)]
        [@debug message="flibberdy" context=links enabled=true /]
        [@debug message="occy" context=occurrence enabled=true /]

        [#-- Extend Spec with extensions.                                        --]
        [#-- Azure only supports two openapi extensions, all others are skipped. --]
        [#-- Extensions: x-ms-paths & x-servers                                  --]
        [#local extendedDefinition = definition]


        [#-- API --]
        [@createApiManagementServiceApi
            id=api.Id
            name=api.Name
            value=extendedDefinition
            path="test"
            dependsOn=[service.Reference]
        /]

        [@createApiManagementServiceApiSchema
            id=schema.Id
            name=schema.Name
            contentType=solution.azure\:ContentType
            dependsOn=[api.Reference]
        /]

    [#else]
        [@fatal message="No API definition exists." context=definitionsObject /]
    [/#if]

    [@createApiManagementServiceProduct
        id=product.Id
        name=product.Name
        dependsOn=[api.Reference]
    /]

    [#-- API Management (APIM) Service --]
    [@createApiManagementService
        id=service.Id
        name=service.Name
        location=regionId
        skuName="Consumption"
        publisherEmail=contact.Email
        publisherName=contact.Name
    /]

[/#macro]