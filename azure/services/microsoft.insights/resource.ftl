[#ftl]

[@addResourceProfile
  service=AZURE_INSIGHTS_SERVICE
  resource=AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2015-04-01",
      "type" : "Microsoft.Insights/autoscaleSettings",
      "outputMappings" : {
        REFERENCE_ATTRIBUTE_TYPE : {
          "Property" : "id"
        }
      }
    }
/]

[#macro createAutoscaleSettings
  id
  name
  location
  targetId
  profiles
  enabled=true
  notifications=[]
  dependsOn=[]]

  [@armResource
    id=id
    name=name
    profile=AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE
    location=location
    dependsOn=dependsOn
    properties=
      {
        "name" : name,
        "enabled" : enabled,
        "profiles" : profiles,
        "targetResourceUri" : targetId
      } +
      attributeIfContent("notifications", notifications)
  /]

[/#macro]