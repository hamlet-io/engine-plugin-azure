[#ftl]
[@addResourceGroupInformation
    type=SPA_COMPONENT_TYPE
    attributes=[
      {
          "Names" : "CORSBehaviours",
          "Description" : "The CORSBehaviours applied to the Storage Account hosting the SPA",
          "Types" : ARRAY_OF_STRING_TYPE,
          "Default" : []
      }
    ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
      [
        AZURE_NETWORK_FRONTDOOR_SERVICE,
        AZURE_STORAGE_SERVICE
      ]
/]

[@addResourceGroupAttributeValues
    type=SPA_COMPONENT_TYPE
    provider=AZURE_PROVIDER
    extensions=[
      {
          "Names" : "Profiles",
          "Children" : [
              {
                  "Names" : "Storage",
                  "Types" : STRING_TYPE,
                  "Default" : "default"
              }
          ]
      }
    ]
/]
