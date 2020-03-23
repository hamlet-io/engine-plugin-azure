[#ftl]

[@addResourceProfile
  service=AZURE_RESOURCES_SERVICE
  resource=AZURE_DEPLOYMENT_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-10-01",
      "type" : "Microsoft.Resources/deployments",
      "outputMappings" : { 
        REFERENCE_ATTRIBUTE_TYPE : {
          "Property" : "id"
        }
      }
    }
/]

[#macro createDeploymentResource
  id
  name
  mode
  location=""
  template={}
  templateLinkUri=""
  templateLinkContentVersion=""
  parameters={}
  parametersLinkUri=""
  parametersLinkContentVersion=""
  debugDetailLevel=""
  onErrorDeploymentType=""
  errorDeploymentName=""
  dependsOn=[]]

  [@armResource 
    id=id
    name=name
    profile=AZURE_DEPLOYMENT_RESOURCE_TYPE
    location=location
    dependsOn=dependsOn
    properties=
      {
        "mode" : mode
      } +
      attributeIfContent("template", template) +
      attributeIfContent("templateLink", {} +
        attributeIfContent("uri", templateLinkUri) +
        attributeIfContent("contentVersion", templateLinkContentVersion)
      ) +
      attributeIfContent("parameters", parameters) +
      attributeIfContent("parametersLink", {} +
        attributeIfContent("uri", parametersLinkUri) +
        attributeIfContent("contentVersion", parametersLinkContentVersion)
      ) +
      attributeIfContent("debugSetting", {} +
        attributeIfContent("detailLevel", debugDetailLevel)
      ) +
      attributeIfContent("onErrorDeployment", {} +
        attributeIfContent("type", onErrorDeploymentType) +
        attributeIfContent("deploymentName", errorDeploymentName)
      )
  /]

[/#macro]

[#-- Convenience Macro - Create a Nested Resource --]
[#-- This macro may no longer be required. Keeping it here until we're certain. --]
[#macro armNestedResource
  id
  name
  profile
  parameters={}
  identity={}
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
  parentNames=[]
  deploymentResourceId="defaultDeploymentResource"
  deploymentResourceName="default"
  deploymentResourceMode="Incremental"
  deploymentResourceParameters={}
  deploymentResourceDependsOn=[]
  location=""]

  [#local resourceProfile = getAzureResourceProfile(profile)]

  [@createDeploymentResource
    id=deploymentResourceId
    name=deploymentResourceName
    mode=deploymentResourceMode
    location=location
    template=
      {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "parameters": parameters,
        "resources": [
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
          attributeIfContent("zones", zones)
        ]
      }
    parameters=deploymentResourceParameters
  /]
[/#macro]