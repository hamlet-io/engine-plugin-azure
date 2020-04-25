[#ftl]

[#function getArmTemplateDefaultOutputs]
    [#return
        {
            REFERENCE_ATTRIBUTE_TYPE : {
                "Attribute" : "id"
            }
        }
    ]
[/#function]

[#function getArmTemplateCoreOutputs
    region=formatAzureResourceGroupReference("location")
    account=formatAzureSubscriptionReference("id")
    resourceGroup=formatAzureResourceGroupReference("id")
    deploymentUnit=getDeploymentUnit()
    deploymentMode=commandLineOptions.Deployment.Mode]

    [#return {
        "Subscription": { "type": "string", "value": account },
        "ResourceGroup": { "type": "string", "value": resourceGroup },
        "Region": { "type": "string", "value": region },
        "DeploymentUnit": {
            "type": "string",
            "value":
                deploymentUnit +
                (
                    (!(ignoreDeploymentUnitSubsetInOutputs!false)) &&
                    (deploymentUnitSubset?has_content)
                )?then(
                    "-" + deploymentUnitSubset?lower_case,
                    ""
                )
        },
        "DeploymentMode" : { "type": "string", "value" : deploymentMode }
    }]
[/#function]

[#macro armOutput name type value condition=""]
    [@mergeWithJsonOutput
        name="outputs"
        content=
            {
                name : {
                    "type" : type,
                    "value" : value
                } +
                attributeIfContent("condition", condition)
            }
    /]
[/#macro]

[#macro addParametersToDefaultJsonOutput id parameter]
   [@addToDefaultJsonOutput
        content=
            {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
                "contentVersion": "1.0.0.0",
                "parameters" : {
                    id : {
                      "value" : parameter
                    }
                }
            }
    /]
[/#macro]

[#macro addReferenceParameterToDefaultJsonOutput id vaultId referenceName]

    [@addToDefaultJsonOutput
        content=
            {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
                "contentVersion": "1.0.0.0",
                "parameters" : {
                    id : getKeyVaultParameter(vaultId, referenceName)
                }
            }
    /]
[/#macro]

[#function pseudoArmStackOutputScript description outputs filesuffix=""]
    [#local outputString = ""]

    [#list getArmTemplateCoreOutputs(region, accountObject.AzureId, commandLineOptions.Deployment.ResourceGroup.Name) as key,value]
        [#if value?is_hash]
            [#local outputs += { key, value.value }]
        [#else]
            [#local outputs += { key, value }]
        [/#if]
    [/#list]

    [#list outputs as key,value]
        [#local outputString +=
          "\"" + key + "\" \"" + value + "\" "
        ]
    [/#list]

    [#return
        [
            "create_pseudo_stack" + " " +
            "\"" + description + "\"" + " " +
            "\"$\{CF_DIR}/$(fileBase \"$\{BASH_SOURCE}\")" + (filesuffix?has_content)?then("-" + filesuffix, "") + "-pseudo-stack.json\" " +
            outputString + " || return $?"
        ]
    ]

[/#function]

[#macro armParameter name type="securestring"]
    [@mergeWithJsonOutput
        name="parameters"
        content=
            {
                name : {
                    "type": type
                }
            }
    /]
[/#macro]

[#macro armResource
    id
    name
    profile
    identity={}
    location=""
    dependsOn=[]
    properties={}
    tags={}
    comments=""
    copy={}
    sku={}
    kind=""
    plan={}
    zones=[]
    resources=[]
    parentNames=[]]

    [#--
        Note - "Identity" is a unique attribute and is not available to resources
        that can be assigned a Managed Identity
    --]

    [#-- TODO(rossmurr4y): impliment localDependencies as the AWS provider does. --]
    [#-- The AWS Provider checks that the dependencies exist with the getReference
        function first, assembles a new array from those that do, and impliments only those.
        The getReference function calls on the getExistingReference function, which has
        some AWS-specific components to it. This will need to be implimented in:
        gen3-azure/azure/services/resource.ftl before it can be utilised. --]
    [#--
        [#local localDependencies = [] ]
        [#list asArray(dependencies) as resourceId]
            [#if getReference(id, name)?is_hash]
                [#local localDependencies += [resourceId] ]
            [/#if]
        [/#list]
    --]

    [#local resourceProfile = getAzureResourceProfile(profile)]

    [@addToJsonOutput
        name="resources"
        content=[
            {
                "name": name,
                "type": resourceProfile.type,
                "apiVersion": resourceProfile.apiVersion,
                "properties": properties
            } +
            attributeIfContent("identity", identity) +
            attributeIfContent("location", location) +
            attributeIfContent("dependsOn", dependsOn) +
            attributeIfContent("tags", tags) +
            attributeIfContent("comments", comments) +
            attributeIfContent("copy", copy) +
            attributeIfContent("sku", sku) +
            attributeIfContent("kind", kind) +
            attributeIfContent("plan", plan) +
            attributeIfContent("zones", zones) +
            attributeIfContent("resources", resources)
        ]
    /]

    [#list resourceProfile.outputMappings as attributeType,attributes]
        [#list attributes as attributeName,attributeValue]

            [#if attributeValue == "id"]
                [#local outputName = id]
                [#local type = "string"]
                [#local value = getReference(id, name)]
            [#else]
                [#-- Properties that are "several": { "levels" : { "deep" : {}}} --]
                [#-- are referenced with a Property value of several.levels.deep --]
                [#local propertySections = attributeValue?split(".")]
                [#local outputName = formatAttributeId(id, propertySections)]
                [#local type = attributeValue?is_hash?then("object","string")]
                [#local typeFull = getAzureResourceProfile(getResourceType(id)).type]
                [#local value = getReference(id, name, typeFull, attributeType, "", "", true, attributeValue)]
            [/#if]

            [@armOutput
                name=outputName
                type=type
                value=value
            /]

        [/#list]
    [/#list]

[/#macro]

[#macro arm_output_resource level="" include=""]

    [#-- Resources --]
    [#if include?has_content]
        [#include include?ensure_starts_with("/")]
    [#else]
        [@processComponents level /]
    [/#if]

    [#if getOutputContent("resources")?has_content || logMessages?has_content]
        [@toJSON
            {
                '$schema': "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": getOutputContent("parameters"),
                "variables": getOutputContent("variables"),
                "resources": getOutputContent("resources"),
                "outputs":
                    getOutputContent("outputs") +
                    getArmTemplateCoreOutputs()
            } +
            attributeIfContent("COTMessages", logMessages)
        /]
    [/#if]
[/#macro]


[#-- Initialise the possible outputs to make sure they are available to all steps --]
[@initialiseJsonOutput name="resources" /]
[@initialiseJsonOutput name="outputs" /]

[#assign AZURE_OUTPUT_RESOURCE_TYPE = "resource" ]

[@addGenerationContractStepOutputMapping
    provider=AZURE_PROVIDER
    subset="template"
    outputType=AZURE_OUTPUT_RESOURCE_TYPE
    outputFormat=""
    outputSuffix="template.json"
/]
