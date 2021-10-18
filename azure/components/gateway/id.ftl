[#ftl]
[@addResourceGroupInformation
  type=NETWORK_GATEWAY_COMPONENT_TYPE
  attributes=[
    {
      "Names" : "Profiles",
      "Children" : [
          {
              "Names" : "Sku",
              "Types" : STRING_TYPE,
              "Default" : "default"
          }
      ]
    },
    {
      "Names" : "engine:Private",
      "Children" : [
        {
          "Names" : "RoutingPolicy",
          "Types" : STRING_TYPE,
          "Values" : [ "RouteBased", "PolicyBased" ],
          "Default" : "RouteBased"
        }
      ]
    }
  ]
  provider=AZURE_PROVIDER
  resourceGroup=DEFAULT_RESOURCE_GROUP
  services=
    [
      AZURE_NETWORK_SERVICE
    ]
/]

[@addResourceGroupInformation
  type=NETWORK_GATEWAY_DESTINATION_COMPONENT_TYPE
  attributes=[]
  provider=AZURE_PROVIDER
  resourceGroup=DEFAULT_RESOURCE_GROUP
  services=
    [
      AZURE_NETWORK_SERVICE
    ]
/]
