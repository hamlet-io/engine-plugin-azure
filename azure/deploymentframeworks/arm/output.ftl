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
    resourceGroup=formatAzureResourceGroupReference("name")
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

[#function getArmOutput name type value condition=""]  
    [#return {
        name : {
            "type" : type,
            "value" : value
        } +
        attributeIfContent("condition", condition)
    }]
[/#function]]

[#function constructArmOutputsFromMappings id name scope mappings=[]]
    [#local result = {}]
    [#switch scope]
        [#case "resourceGroup"]

            [#-- redirect values to nested resource outputs --]
            [#list mappings as attributeType,attributes]
                [#local dataType = getOutputMappingDataType(attributeType)]
                [#list attributes as attributeName,attributeValue]
                    [#if attributeValue == "id"]
                        [#local outputName = id]
                        [#local value = getReference(id, name)]
                    [#else]
                        [#local propertySections = attributeValue?split(".")]
                        [#local outputName = formatAttributeId(id, propertySections)]
                        [#local typeFull = getAzureResourceProfile(getResourceType(id)).type]
                        [#local value = getReference(id, name, typeFull, attributeType, "", "", true, attributeValue)]
                    [/#if]
                    [#local result += getArmOutput(outputName, dataType, value)]
                [/#list]
            [/#list]
            [#break]

        [#case "template"]
            [#list mappings as attributeType,attributes]

                [#local dataType = getOutputMappingDataType(attributeType)]
                [#list attributes as attributeName,attributeValue]
                    [#if attributeValue == "id"]
                        [#local outputName = id]
                        [#local value = getReference(id, name)]
                        [#break]
                    [#else]
                        [#local propertySections = attributeValue?split(".")]
                        [#local outputName = formatAttributeId(id, propertySections)]
                        [#local typeFull = getAzureResourceProfile(getResourceType(id)).type]
                        [#local value = getReference(id, name, typeFull, attributeType, "", "", true, attributeValue)]
                        [#break]
                    [/#if]
                    [#local result += getArmOutput(outputName, dataType, value)]
                [/#list]
            [/#list]
            [#break]

        [#case "pseudo"]
            [#return getArmOutput(name, "string", "pseudo")]
            [#break]

    [/#switch]
    [#return result]
[/#function]

[#macro addParametersToDefaultJsonOutput id parameter]
   [@addToDefaultJsonOutput
        content=
            {
                "$schema": ARMSchemas.Parameters,
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
                "$schema": ARMSchemas.Parameters,
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

[#macro armParameter name type="securestring" default=""]
    [@mergeWithJsonOutput
        name="parameters"
        content=
            {
                name : {
                    "type": type
                } +
                attributeIfContent("defaultValue", default)
            }
    /]
[/#macro]

[#macro armVariable name value]
    [@mergeWithJsonOutput
        name="variables"
        content={ name : value }
    /]
[/#macro]

[#function getOutputMappingDataType type]
    [#switch type]
        [#case DICTIONARY_ATTRIBUTE_TYPE]
            [#return "object"]
            [#break]

        [#default]
            [#return "string"]
            [#break]
    [/#switch]
[/#function]

[#-- scope of a resource relative to the current runtime state. --]
[#function getResourceRelativeScope id]
    [#-- scope determination:                                                                       --]
    [#--    * determine current runtime scope.                                                      --]
    [#--    * compare with scope of evaluated resource.                                             --]
    [#--    * construct relativeScope - attributes indicate a variance from the current resource.   --]
    [#--    * assign a scope level - a label identifying the scope.                                 --]
    [#--        * ensure scope level does not go below the resource scope marker.                   --]
    [#--          The marker indicates the minimum scope to which a resource exists.                --]
    [#local resourceProfileScope = getAzureResourceProfile(getResourceType(id).Scope)]

    [#local targetScope = mergeObjects(
            getStackOutputObject((commandLineOptions.Deployment.Provider.Names)[0], id),
            getExistingReference(id, "ResourceGroup"),
            getExistingReference(id, "Subscription"))]

    [#local currentScope = {
        "Subscription" : accountObject.AzureId,
        "Region" : regionId,
        "ResourceGroup" : commandLineOptions.Deployment.ResourceGroup.Name,
        "DeploymentUnit" : getDeploymentUnit()}]

    [#local relativeScope = {} +
        attributeIfTrue("Subscription", (currentScope.Subscription != targetScope.Subscription), targetScope.Subscription) +
        attributeIfTrue("Region", (currentScope.Region != targetScope.Region), targetScope.Region) + 
        attributeIfTrue("ResourceGroup", (currentScope.ResourceGroup != targetScope.ResourceGroup), targetScope.ResourceGroup) +
        attributeIfTrue("DeploymentUnit", (currentScope.DeploymentUnit != targetScope.DeploymentUnit), targetScope.DeploymentUnit)]
    
    [#-- scope level --]
    [#-- The existence of attributes in the relativeScope object indicate --]
    [#-- cross-scope at that level.                                       --]
    [#local scopeLevels = ["template", "resourceGroup", "subscription", "pseudo"] ]
    [#local resourceDefaultScopeLevel = resourceProfileScope]
    [#if relativeScope?keys?seq_contains("Subscription")]
        [#local relativeScopeLevel = "subscription"]
    [#elseif relativeScope?keys?seq_contains("ResourceGroup") || relativeScope?keys?seq_contains("DeploymentUnit")]
        [#local relativeScopeLevel = "resourceGroup" ]
    [#elseif isPartOfCurrentDeploymentUnit(id)]
        [#local relativeScopeLevel = "template"]
    [#else]
        [@fatal
            message="Resource relative scope could not be determined."
            context={
                "ResourceId" : id,
                "CurrentScope" : currentScope,
                "RelativeScope" : relativeScope
            }
        /]
    [/#if]

    [#-- Use the relative level only down to the level of the default. --]
    [#-- Some resources only exist at the higher scopes.               --]
    [#if scopeLevels?seq_index_of(relativeScopeLevel) < scopeLevels?seq_index_of(resourceDefaultScopeLevel)]
        [#local relativeScope += { "Level" : resourceDefaultScopeLevel }]
    [#else]
        [#local relativeScope += { "Level" : relativeScopeLevel }]
    [/#if]

    [#return relativeScope]
[/#function]

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
    resourceGroupId=""
    subscriptionId=""
    parentId=""]

    [#local resourceProfile = getAzureResourceProfile(profile)]
    [#local resourceOutputs = constructArmOutputsFromMappings(resourceProfile.outputMappings)]
    [#local resourceLocation = resourceProfile.global?then("global", location)]
    
    [#if parentId?has_content]
        [#local resourceScope = getResourceRelativeScope(parentId)]
    [#else]
        [#local resourceScope = getResourceRelativeScope(id)]
    [/#if]

    [#-- Construct Current Resource Object --]
    [#if !(resourceScope.Level == "pseudo")]
        [#local resourceContent = {
                    "name": name,
                    "type": resourceProfile.type,
                    "apiVersion": resourceProfile.apiVersion,
                    "properties": properties
                } +
                attributeIfContent("resourceGroup", resourceGroup) +
                attributeIfContent("subscriptionId", subscriptionId) +
                attributeIfContent("identity", identity) +
                attributeIfContent("location", resourceLocation) +
                attributeIfContent("dependsOn", dependsOn) +
                attributeIfContent("tags", tags) +
                attributeIfContent("comments", comments) +
                attributeIfContent("copy", copy) +
                attributeIfContent("sku", sku) +
                attributeIfContent("kind", kind) +
                attributeIfContent("plan", plan) +
                attributeIfContent("zones", zones) +
                attributeIfContent("resources", resources)]
    [/#if]

    [#switch resourceScope.Level]

        [#case "subscription"]
        [#case "resourceGroup"]
            [@armResource
                id=formatResourceId(AZURE_DEPLOYMENT_RESOURCE_TYPE, id)
                name=formatAzureResourceName(name, AZURE_DEPLOYMENT_RESOURCE_TYPE)
                profile=AZURE_DEPLOYMENT_RESOURCE_TYPE
                properties=
                    {
                        "template": {
                            "$schema": ARMSchemas.Template,
                            "contentVersion": "1.0.0.0",
                            "parameters": {},
                            "resources": [resourceContent],
                            "outputs": resourceOutputs
                        }
                    }
                scope=resourceScope.Level
                resourceGroup=resourceGroup
                dependsOn=dependsOn
            /]
            [@mergeWithJsonOutput
                name="outputs"
                content=resourceOutputs
            /]
            [#break]

        [#case "template"]
            [@addToJsonOutput
                name="resources"
                content=[resourceContent]
            /]
            [@mergeWithJsonOutput
                name="outputs"
                content=resourceOutputs
            /]
            [#break]

        [#case "pseudo"]
            [@mergeWithJsonOutput
                name="outputs"
                content=resourceOutputs
            /]
            [#break]

        [#default]
            [@fatal
                message="Unknown or missing resource scope."
                context=resourceScope
            /]
            [#break]
    [/#switch]
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
                '$schema': ARMSchemas.Template,
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
