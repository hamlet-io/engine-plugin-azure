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
[/#function]

[#function constructArmOutputsFromMappings id name scope mappings=[]]
    [#local result = {}]
    [#list mappings as attributeType,attributes]
        [#local dataType = getOutputMappingDataType(attributeType)]
        [#list attributes as attributeName,attributeValue]

            [#switch scope]

                [#case "subscription"]
                [#case "resourceGroup"]
                    [#if attributeValue == "id"]
                        [#local typeFull = getAzureResourceProfile(AZURE_DEPLOYMENT_RESOURCE_TYPE).type]
                        [#local propertySections = attributeValue?split(".")]
                        [#local outputName = id]
                        [#local value = getReference(id, name, typeFull, "", "", "", true, "outputs." + outputName + ".value")]
                    [#else]
                        [#local typeFull = getAzureResourceProfile(AZURE_DEPLOYMENT_RESOURCE_TYPE).type]
                        [#local propertySections = attributeValue?split(".")]
                        [#local outputName = formatAttributeId(id, propertySections)]
                        [#local value = getReference(id, name, typeFull, attributeType, "", "", true, "outputs." + outputName + ".value")]
                    [/#if]
                    [#break]

                [#case "template"]
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
                    [#break]

                [#case "pseudo"]
                    [#return getArmOutput(name, "string", "pseudo")]
                    [#break]

            [/#switch]
            [#local result += getArmOutput(outputName, dataType, value)]
        [/#list]
    [/#list]
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

[#-- Deconstruct a resourceId value into discovered scopes --]
[#function getResourceScopeFromResourcePath id]
    [#local segments = getAzureResourceNameSegments(id)]
    [#local subscriptionIndex = segments?seq_index_of("subscriptions")!""]
    [#local resourceGroupIndex = segments?seq_index_of("resourceGroups")!""]
    [#local providerIndex = segments?seq_index_of("providers")!""]
    [#local resourceIndex = segments?size - 2]
    [#local resourceSegments = segments?filter(s -> segments?seq_index_of(s) >= resourceIndex)]
    [#local parentSegments = segments?filter(s -> segments?seq_index_of(s) > (providerIndex + 1) && segments?seq_index_of(s) < resourceIndex)![]]
    [#local end = segments?size - 1]
    [#local parents = []]

    [#-- Segments remaining in an Id after the provider value are parents --]
    [#if parentSegments?has_content]
        [#list parentSegments as segment]
            [#if segment?item_parity == "odd" && segment?has_next]
                [#local segmentIndex = parentSegments?seq_index_of(segment)]
                [#local parents += [
                    {
                        "Index" : segment?counter,
                        "Name" : parentSegments[segmentIndex + 1],
                        "Type" : parentSegments[segmentIndex]
                    }
                ]]
            [/#if]
        [/#list]
    [/#if]

    [#return 
        {
            "Resource" : {
                "Name" : segments?sequence[resourceIndex + 1],
                "Type" : segments?sequence[resourceIndex]
            }
        } +
        attributeIfContent("Subscription", segments?sequence[subscriptionIndex + 1]!"") +
        attributeIfContent("ResourceGroup", segments?sequence[resourceGroupIndex + 1]!"") +
        attributeIfContent("Provider", segments?sequence[providerIndex + 1]!"") +
        attributeIfContent("Parents", parents)]
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
    [#local resourceProfileScope = getAzureResourceProfile(getResourceType(id)).scope]
    [#local currentScope = {
        "Subscription" : accountObject.AzureId,
        "Region" : regionId,
        "ResourceGroup" : commandLineOptions.Deployment.ResourceGroup.Name
    }]

    [#if isPartOfCurrentDeploymentUnit(id)]
        [#local relativeScope = {}]
    [#else]
        [#local resourceId = getExistingReference(id)]    
        [#if resourceId?has_content]
            [#local targetScope = getResourceScopeFromResourcePath(resourceId)]
            [#local relativeScope = {} +
                attributeIfTrue("Subscription", !currentScope.Subscription?matches(targetScope.Subscription!""), targetScope.Subscription!"") +
                attributeIfTrue("ResourceGroup", !currentScope.ResourceGroup?matches(targetScope.ResourceGroup!""), targetScope.ResourceGroup!"")]
        [#else]
            [@fatal
                message="Could not find existing reference for Id"
                context={ "Id" : id }
            /]
        [/#if]
    [/#if]

    [#-- scope level --]
    [#-- The existence of attributes in the relativeScope object indicate --]
    [#-- cross-scope at that level.                                       --]
    [#local scopeLevels = ["template", "resourceGroup", "subscription", "pseudo"] ]
    [#if resourceProfileScope == "pseudo"]
        [#local relativeScopeLevel = "pseudo"]
    [#elseif relativeScope?keys?seq_contains("Subscription")]
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
    [#if scopeLevels?seq_index_of(relativeScopeLevel) < scopeLevels?seq_index_of(resourceProfileScope)]
        [#local relativeScope += { "Level" : resourceProfileScope }]
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
    
    [#if parentId?has_content]
        [#local resourceScope = getResourceRelativeScope(parentId)]
        [#local resourceGroupId = resourceScope.ResourceGroup!""]
        [#local subscriptionId = resourceScope.Subscription!""]
    [#else]
        [#local resourceScope = getResourceRelativeScope(id)]
    [/#if]
    [#local resourceProfile = getAzureResourceProfile(profile)]
    [#local resourceLocation = resourceProfile.global?then("global", location)]

    [#-- Construct Current Resource Object --]
    [#if !(resourceScope.Level == "pseudo")]
        [#local resourceContent = {
                    "name": name,
                    "type": resourceProfile.type,
                    "apiVersion": resourceProfile.apiVersion,
                    "properties": properties
                } +
                attributeIfContent("resourceGroup", resourceGroupId) +
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
            [#local deploymentOutputs = constructArmOutputsFromMappings(id, name, resourceScope.Level, resourceProfile.outputMappings)]
            [#local templateOutputs = constructArmOutputsFromMappings(id, name, "template", resourceProfile.outputMappings)]
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
                            "outputs": templateOutputs
                        }
                    }
                resourceGroupId=resourceGroupId
                subscriptionId=subscriptionId
                dependsOn=dependsOn
            /]
            [@mergeWithJsonOutput
                name="outputs"
                content=deploymentOutputs
            /]
            [#break]

        [#case "template"]
            [#local templateOutputs = constructArmOutputsFromMappings(id, name, resourceScope.Level, resourceProfile.outputMappings)]
            [@addToJsonOutput
                name="resources"
                content=[resourceContent]
            /]
            [@mergeWithJsonOutput
                name="outputs"
                content=templateOutputs
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
