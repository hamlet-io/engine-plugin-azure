[#ftl]

[#-- Azure Resource Profiles --]
[#assign azureResourceProfiles = {}]
[#assign azureResourceProfilesConfiguration = 
    {
        "Properties" : [
            {
                "Type" : "",
                "Value" : "Attributes of a Resource Profile."
            }
        ],
        "Attributes" : [
            {
                "Names" : "type",
                "Type" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "apiVersion",
                "Type" : STRING_TYPE,
                "Mandatory" : true
            },
            {
                "Names" : "conditions",
                "Type" : ARRAY_OF_STRING_TYPE,
                "Default" : []
            },
            {
                "Names" : "max_name_length",
                "Type" : NUMBER_TYPE,
                "Mandatory" : false
            },
            {
                "Names" : "outputMappings",
                "type" : OBJECT_TYPE,
                "Mandatory" : true
            }
        ]
    }
]

[#macro addResourceProfile service resource profile]
    [@internalMergeResourceProfiles
        service=service
        resource=resource
        profile=profile
    /]

    [#-- Update outputMappings from profile
        Though outputMappings are now accessible from the profile, its important to use
        "outputMapping" variable to support cross-provider implementation.          --]
    [@addOutputMapping 
        provider=AZURE_PROVIDER
        resourceType=resource
        mappings=profile.outputMappings
    /]
[/#macro]

[#-- Pseudo Resource Profiles are for resources that do not correspond --]
[#-- directly with an Azure ARM Resource type, but require an output.  --]
[#macro addPseudoResourceProfile service resource]
    [@addResourceProfile
        service=service
        resource=resource
        profile=
            {
                "apiVersion" : "pseudo",
                "type" : "pseudo",
                "outputMappings" : {
                    REFERENCE_ATTRIBUTE_TYPE: {
                        "Property" : "pseudo"
                    }
                }
            }
    /]
[/#macro]

[#-- Formats a given resourceId into a Azure ARM lookup function for the current state of
a resource, be it previously deployed or within current template. This differs from
the previous function as the ARM function will return a full object, from which attributes
can be referenced via dot notation. --]
[#function getReference
    resourceId
    resourceName,
    typeFull=""
    outputType=REFERENCE_ATTRIBUTE_TYPE
    subscriptionId=""
    resourceGroupName=""
    fullResource=true
    attributes...]

    [#-- get short type - used for apiVersion + conditions --]
    [#local resourceType = getResourceType(resourceId)]
    [#local resourceProfile = getAzureResourceProfile(resourceType)]
    [#local apiVersion = resourceProfile.apiVersion]
    [#local conditions = resourceProfile.conditions]

    [#local nameSegments = getAzureResourceNameSegments(resourceName)]

    [#-- get long type - used for referencing resources in ARM functions --]
    [#if typeFull == ""]
        [#local typeFull = resourceProfile.type]
    [/#if]

    [#-- Provide a full resource object or just the properties object --]
    [#if fullResource]
        [#local fullOrPartReference = "', 'Full'"]
    [#else]
        [#local fullOrPartReference = "'"]
    [/#if]

    [#if !(resourceProfile.type == "pseudo")]
        [#if isPartOfCurrentDeploymentUnit(resourceId)]
            [#if outputType = REFERENCE_ATTRIBUTE_TYPE]

                [#-- return a reference to the resourceId --]
                [#local args = []]
                [#list [subscriptionId, resourceGroupName, typeFull] as arg]
                    [#if arg?has_content]
                        [#local args += [arg]]
                    [/#if]
                [/#list]

                [#list nameSegments as segment]
                    [#local args += [segment]]
                [/#list]

                [#return "[resourceId('" + concatenate(args, "', '") + "')]" ]
            [#else]
                [#if attributes?size = 1 && attributes?last = "name" ]
                    [#-- "name" isn't a referencable attribute - but we already have access to it. --]
                    [#return resourceName]
                [#else]
                    [#-- return a reference to the specific resources attributes. --]
                    [#-- Example: "[reference(resourceId(resourceType, resourceName), '0000-00-00', 'Full').properties.attribute]" --]
                    [#return
                        "[reference(resourceId('" + typeFull + "', '" + concatenate(nameSegments, "', '") + "'), '" + apiVersion + fullOrPartReference + ")." + asFlattenedArray(attributes, true)?join(".") + "]"
                    ]
                [/#if]
            [/#if]
        [#else]
            [#if ! (attributes?size = 0) ]
                [#-- return a reference to the specific resources attributes in another Deployment Unit --]
                [#-- Example: "[reference(resourceId(subscriptionId, resourceGroupName, resourceType, resourceName), '0000-00-00', 'Full').properties.attribute]" --]
                [#return
                    "[reference(resourceId('" + subscriptionId + "', '" + resourceGroupName + "', '" + typeFull + "', '" + concatenate(nameSegments, "', '") + "'), '" + apiVersion + fullOrPartReference + ")." + asFlattenedArray(attributes, true)?join(".") + "]"
                ]
            [#else]
                [#return getExistingReference(
                    resourceId,
                    attributeType,
                    "",
                    "",
                    (subscriptionId?has_content)?then(
                        subscriptionId,
                        ""
                    )
                )]
            [/#if]
        [/#if]
    [#else]
        [#-- Pseudo-resources simply output their name.           --]
        [#-- By doing so, a component can be considered deployed. --]
        [#return resourceName]
    [/#if]
[/#function]

[#-- Some Azure resources need to be referened by their resourceId without being
a resource themselves. This function will create the correct ARM reference to
such an object Id through parent/grandparent Ids/Names --]
[#function getSubReference 
    resourceId
    resourceName
    childType
    childName
    grandChildType=""
    grandChildName=""
    subscriptionId=""
    resourceGroupName=""
    fullResource=false
    attributes...]

    [#local names = [resourceName, childName]]
    [#if grandChildName?has_content]
        [#local names += [grandChildName]]
    [/#if]

    [#local types = [getAzureResourceProfile(getResourceType(resourceId)).type, childType]]
    [#if grandChildType?has_content]
        [#local types += [grandChildType]]
    [/#if]

    [#return
        getReference(
            resourceId,
            names?join('/'),
            types?join('/'),
            REFERENCE_ATTRIBUTE_TYPE,
            subscriptionId,
            resourceGroupName,
            fullResource,
            attributes
        )
    ]

[/#function]

[#function getParameterReference parameterName]
    [#return 
        "[parameters('" + parameterName + "')]"
    ]
[/#function]

[#-- turn a list of resource Id's into an array of objects with a key of "id". --]
[#-- i.e [{"id": "<resource 1 reference>"}, {"id", "<resource 2 reference>"}] --]
[#-- this is a common way for one azure resource to reference another sub-resource --]
[#function getSubResourceReference id]
    [#return {"id": id}]
[/#function]
[#function getSubResourceReferences ids...]
    [#local results = {}]
    [#list ids as id]
        [#local results += getSubResourceReference(id)]
    [/#list]
    [#return results]
[/#function]

[#--Formats a reference to a subscription's attributes:
id, subscriptionId, tenantId or displayName --]
[#function formatAzureSubscriptionReference attribute=""]
 [#return
    "[subscription()" + (attribute?has_content)?then(attribute?ensure_starts_with("."), "") + "]"
 ]
[/#function]

[#--Formats a reference to a resourceGroups attributes:
id, name, type, location, managedBy, tags, properties.provisioningState --]
[#function formatAzureResourceGroupReference attribute=""]
 [#return
    "[resourceGroup()" + (attribute?has_content)?then(attribute?ensure_starts_with("."), "") + "]"
 ]
[/#function]

[#-- 
    Azure has strict rules around resource name "segments" (parts seperated by a '/'). 
    The rules that must be adhered to are:
        - A root level resource must have one less segment in the name than the 
            resource type (typically just the 1 segment).
        - Child resources must have the same number of segments as the child type.
            (this is typically 1 for the child, and 1 per parent resource.)
--]
[#function formatAzureResourceName name profile primaryParent=""]
    
    [#local resourceProfile = getAzureResourceProfile(profile)]
    [#local conditions = resourceProfile.conditions]
    [#local conditions += ["segment_out_names"]]
    [#list conditions as condition]
        [#switch condition]
            [#case "alphanumeric_only"]
                [#local name = name?split("-")?join("")]
                [#break]
            [#case "globally_unique"]
                [#local segmentSeed = getStackOutput(AZURE_PROVIDER, formatSegmentResourceId("seed"))]
                [#local name = name?ensure_ends_with(segmentSeed)]
                [#break]
            [#case "max_length"]
                [#if name?length > resourceProfile.max_name_length]
                    [#local name = name[0..(resourceProfile.max_name_length - 1)]]
                [/#if]
                [#break]
            [#case "name_to_lower"]
                [#local name = name?lower_case]
                [#break]
            [#case "parent_to_lower"]
                [#local primaryParent = primaryParent?lower_case ]
                [#break]
            [#case "segment_out_names"]
                [#-- This will always happen last --]
                [#local name = formatRelativePath( (primaryParent!""), name?remove_ending("-"))]
                [#break]
            [#default]
                [@fatal
                    message="Error formatting Resource Id Reference: Azure Resource Profile Condition does not exist."
                    context=condition
                /]
                [#break]
        [/#switch]
    [/#list]

    [#return name]

[/#function]

[#function getAzureResourceNameSegments resourceName]
    [#return resourceName?split("/")]
[/#function]

[#function getAzureResourceProfile resourceType serviceType=""]

    [#-- Service has been provided, so lookup can be specific --]
    [#if serviceType?has_content]
        [#list azureResourceProfiles[serviceType] as resource, attr]
            [#if resource == resourceType]
                [#local profileObj = azureResourceProfiles[serviceType][resource]]
            [/#if]
        [/#list]
    [#else]
        [#-- Service has not been specific, check all Services for the resourceType --]
        [#list azureResourceProfiles as service, resources]
            [#list resources as resource, attr]
                [#if resource = resourceType]
                    [#local profileObj = attr]
                [/#if]
            [/#list]
        [/#list]
    [/#if]

    [#if profileObj?has_content]
        [#return profileObj]
    [#else]
        [#return
            {
                "Mapping" : "COTFatal: ResourceProfile not found.",
                "ServiceType" : serviceType,
                "ResourceType" : resourceType,
                "apiVersion" : "COTFatal: ResourceProfile not found.",
                "conditions" : [],
                "type" : "Hamlet/UnknownType"
            }
        ]
    [/#if]
[/#function]

[#-- Get stack output --]
[#function getExistingReference resourceId attributeType="" inRegion="" inDeploymentUnit="" inAccount=""]
    [#local attributeType = (attributeType == REFERENCE_ATTRIBUTE_TYPE)?then(
                                "",
                                attributeType
    )]

    [#return getStackOutput(AZURE_PROVIDER, formatAttributeId(resourceId, attributeType), inDeploymentUnit, inRegion, inAccount) ]
[/#function]

[#-- Due to azure resource names having multiple segments, Azure requires
its own function to return the first split of the last segment --]
[#function getAzureResourceType resourceId]
    [#return resourceId?split("/")?last?split("X")[0]]
[/#function]

[#-- Formats a call to the Azure ARM "concat" function. --]
[#function formatAzureConcatFunction segments...]
    [#local parts = asArray(segments)?join("', '")]
    [#return "[concat('" + parts + "')]"]
[/#function]

[#-- Formats a call to the Azure Arm "string() function     --]
[#-- output the params as ARM parameters. This puts the     --]
[#-- params in another file, keeping the template tidy and  --]
[#-- allows us to easily call the ARM function "string()"   --]
[#-- on them, to pass them inline as necessary.             --]
[#-- This is particularly helpful when the string is huge.  --]
[#function formatAzureStringFunction stringFormat="" parameters...]
    [#local args = stringFormat?has_content?then([stringFormat, parameters], [parameters])]
    [#return "[string(" + asFlattenedArray(args)?join("', '") + ")]"]
[/#function]

[#-- 
    Azure has some default tags to reference standard IP ranges.
    We use that here as Azure does not accept 0.0.0.0/0 as reference to Internet.
--]
[#function formatAzureIPAddress ip]
    [#local result = ""]
    [#if ip?has_content]
        [#local result = ip?replace("0.0.0.0/0", "Internet")]
    [/#if]
    [#return result]
[/#function]

[#function formatAzureIPAddresses ipAddresses...]
    [#local result = []]
    [#list ipAddresses as ip]
        [#if ip?has_content]
            [#local result += [formatAzureIPAddress(ip)]]
        [/#if]
    [/#list]
    [#return result]
[/#function]

[#function getAzServiceEndpoint serviceName serviceType resourceName extensions...]

    [#local endpoints = {}]
    [#switch serviceName]
        [#case "Microsoft.ContainerRegistry"]
            [#local endpoints =
                {
                    "containerRegistry" : "azurecr.io"
                }
            ]
            [#break]
        [#case "Microsoft.KeyVault"]
            [#local endpoints =
                {
                    "vault" : "vault.azure.net/"
                }
            ]
            [#break]
        [#case "Microsoft.Storage"]
            [#local endpoints = 
                {
                    "blob"  : "blob.core.windows.net/",
                    "dfs"   : "dfs.core.windows.net/",
                    "file"  : "file.core.windows.net/",
                    "queue" : "queue.core.windows.net/",
                    "table" : "table.core.windows.net/",
                    "web"   : "web.core.windows.net/"
                }
            ]
        [#default]
            [@fatal
                message="Unsupported Azure Endpoint Service specified."
                context=
                    {
                        "serviceName" : serviceName,
                        "serviceType" : serviceType,
                        "resourceName" : resourceName,
                        "extensions" : extensions
                    }
            /]
    [/#switch]

    [#local endpoint = 
        "https://" +
        resourceName +
        extensions?join(".")?ensure_starts_with(".")?ensure_ends_with(".") +
        endpoints[serviceType]
    ]

    [#return endpoint]

[/#function]
[#-------------------------------------------------------
-- Internal support functions for resource processing --
---------------------------------------------------------]

[#macro internalMergeResourceProfiles service resource profile]
    [#if profile?has_content ]
        [#assign azureResourceProfiles = 
            mergeObjects(
                azureResourceProfiles,
                { 
                    service : {
                        resource : getCompositeObject(
                            azureResourceProfilesConfiguration.Attributes,
                            profile
                        )
                    }
                } 
            )
        ]
    [/#if]
[/#macro]

[#-- Function for determining if a Managed Identity is required. --]
[#function getAzureManagedIdentity linkTarget]
    [#return (linkTarget.Role)?has_content?then({ "type" : "SystemAssigned" },{})]
[/#function]