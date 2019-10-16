[#ftl]

[#macro azure_gateway_arm_state occurrence parent={} baseState={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]
  [#local engine = solution.Engine ]
 
  [#if engine == "vpcendpoint"]
    [#-- 
      A private DNS Zone is required so we can force routing to the endpoint to remain within the
      VNet. If we don't then default routing may send traffic via the Internet.
    --]

    [#assign componentState =
      {
        "Resources" : {
          "dnsZone" : {
            "Id" : formatDependentResourceId(AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE, core.TypedName),
            "Type" : AZURE_PRIVATE_DNS_ZONE_RESOURCE_TYPE
          },
          "vnetLink" : {
            "Id" : formatDependentResourceId(AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE, core.Id),
            "Type" : AZURE_PRIVATE_DNS_ZONE_VNET_LINK_RESOURCE_TYPE
          }
        },
        "Attributes" : {},
        "Roles" : {
          "Inbound" : {},
          "Outbound" : {}
        }
      }
    ]
      
  [#else]
    [@fatal
      message="Unknown Engine Type"
      context=occurrence.Configuration.Solution
    /]
  [/#if]

[/#macro]

[#macro azure_gatewaydestination_arm_state occurrence parent={} baseState={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#local parentCore = parent.Core]
  [#local parentSolution = parent.Configuration.Solution]
  [#local engine = parentSolution.Engine]

  [#local resources = {}]

  [#if engine == "vpcendpoint"]

    [#local networkEndpoints = getNetworkEndpoints(solution.NetworkEndpointGroups, "a", region)]
      
    [#list networkEndpoints as id, networkEndpoint]

      [#local resources = mergeObjects(resources,
        {
          "endpointPolicy" : {
            "Id" : formatResourceId(AZURE_SERVICE_ENDPOINT_POLICY_RESOURCE_TYPE, id),
            "Name" : formatName(AZURE_SERVICE_ENDPOINT_POLICY_RESOURCE_TYPE, id),
            "Type" : AZURE_SERVICE_ENDPOINT_POLICY_RESOURCE_TYPE
          },
          "endpointPolicyDefinitions" : {
            id : {
              "Id" : formatDependentResourceId(AZURE_SERVICE_ENDPOINT_POLICY_DEFINITION_RESOURCE_TYPE, core.Id, replaceAlphaNumericOnly(id, "X")),
              "Name" : formatName(AZURE_SERVICE_ENDPOINT_POLICY_DEFINITION_RESOURCE_TYPE, id),
              "EndpointType" : networkEndpoint.Type?lower_case,
              "ServiceName" : networkEndpoint.ServiceName,
              "Type" : AZURE_SERVICE_ENDPOINT_POLICY_DEFINITION_RESOURCE_TYPE
            }
          }
        }
      )]

    [/#list]

    [#assign componentState =
      {
        "Resources" : resources,
        "Attributes" : {
          "Engine" : parentSolution.Engine
        },
        "Roles" : {
          "Inbound" : {},
          "Outbound" : {}
        }
      }
    ]

  [#else]
    [@fatal
        message="Unknown Engine Type"
        context=occurrence.Configuration.Solution
    /]
  [/#if]

[/#macro]
