[#ftl]

[@addResourceProfile 
  service=AZURE_NETWORK_FRONTDOOR_SERVICE
  resource=AZURE_FRONTDOOR_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-05-01",
      "type" : "Microsoft.Network/frontDoors"
    }
/]

[@addResourceProfile 
  service=AZURE_NETWORK_FRONTDOOR_SERVICE
  resource=AZURE_FRONTDOOR_WAF_POLICY_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-03-01",
      "type" : "Microsoft.Network/FrontDoorWebApplicationFirewallPolicies"
    }
/]

[#assign FRONTDOOR_OUTPUT_MAPPINGS = 
  {
    REFERENCE_ATTRIBUTE_TYPE : {
      "Property" : "id"
    }
  }
]

[#assign FRONTDOOR_WAF_POLICY_OUTPUT_MAPPINGS = 
  {
    REFERENCE_ATTRIBUTE_TYPE : {
      "Property" : "id"
    }
  }
]

[@addOutputMapping 
  provider=AZURE_PROVIDER
  resourceType=AZURE_FRONTDOOR_RESOURCE_TYPE
  mappings=FRONTDOOR_OUTPUT_MAPPINGS
/]

[@addOutputMapping 
  provider=AZURE_PROVIDER
  resourceType=AZURE_FRONTDOOR_WAF_POLICY_RESOURCE_TYPE
  mappings=FRONTDOOR_WAF_POLICY_OUTPUT_MAPPINGS
/]


[#function getFrontDoorRoutingRule
  id=""
  name=""
  frontendEndpoints=[]
  acceptedProtocols=[]
  patternsToMatch=[]
  routeODataType=""]

  [#return
    {} +
    attributeIfContent("id", id) +
    attributeIfContent("name", name) +
    attributeIfContent("properties", {} +
      attributeIfContent("frontendEndpoints", frontendEndpoints) +
      attributeIfContent("acceptedProtocols", acceptedProtocols) +
      attributeIfContent("patternsToMatch", patternsToMatch) +
      attributeIfContent("routeConfiguration", {} +
        attributeIfContent("@odata.type", routeODataType)
      )
    )
  ]
[/#function]

[#function getFrontDoorLoadBalancingSettings
  id=""
  name=""
  sampleSize=""
  successfulSamplesRequired=""
  additionalLatencyMilliseconds=""]

  [#return {} +
    attributeIfContent("id", id) +
    attributeIfContent("name", name) +
    attributeIfContent("properties", {} +
      attributeIfContent("sampleSize", sampleSize) +
      attributeIfContent("successfulSamplesRequired", successfulSamplesRequired) +
      attributeIfContent("additionalLatencyMilliseconds", additionalLatencyMilliseconds)
    )
  ]
[/#function]

[#function getFrontDoorHealthProbeSettings
  id=""
  name=""
  path=""
  protocol=""
  intervalInSeconds=""
  healthProbeMethod=""]

  [#return {} +
    attributeIfContent("id", id) +
    attributeIfContent("name", name) +
    attributeIfContent("properties", {} +
      attributeIfContent("path", path) +
      attributeIfContent("protocol", protocol) +
      attributeIfContent("intervalInSeconds", intervalInSeconds) +
      attributeIfContent("healthProbeMethod", healthProbeMethod)
    )
  ]
[/#function]

[#function getFrontDoorBackend
  address=""
  httpPort=""
  httpsPort=""
  priority=""
  weight=""
  backendHostHeader=""]

  [#return {} +
    attributeIfContent("address", address) +
    attributeIfContent("httpPort", httpPort) +
    attributeIfContent("httpsPort", httpsPort) +
    attributeIfContent("priority", priority) +
    attributeIfContent("weight", weight) +
    attributeIfContent("backendHostHeader", backendHostHeader)
  ]
[/#function]

[#function getFrontDoorBackendPool
  id=""
  name=""
  backends=[]
  loadBalancingSettings={}
  healthProbeSettings={}]
  [#return
    {} +
    attributeIfContent("id", id) +
    attributeIfContent("name", name) +
    attributeIfContent("properties", {} +
      attributeIfContent("backends", backends) +
      attributeIfContent("loadBalancingSettings", loadBalancingSettings) +
      attributeIfContent("healthProbeSettings", healthProbeSettings)
    )
  ]
[/#function]

[#function getFrontDoorFrontendEndpoint
  id=""
  name=""
  hostName=""
  sessionAffinityEnabledState=""
  sessionAffinityTtlSeconds=""
  webApplicationFirewallPolicyLinkId=""]

  [#return {} +
    attributeIfContent("id", id) +
    attributeIfContent("name", name) +
    attributeIfContent("properties", {} +
      attributeIfContent("hostName", hostName) +
      attributeIfContent("sessionAffinityEnabledState", sessionAffinityEnabledState) +
      attributeIfContent("sessionAffinityTtlSeconds", sessionAffinityTtlSeconds) +
      attributeIfContent("webApplicationFirewallPolicyLink", {} +
        attributeIfContent("id", webApplicationFirewallPolicyLinkId)
      )
    )
  ]
[/#function]

[#macro createFrontDoor
  id
  name
  friendlyName=""
  routingRules=[]
  loadBalancingSettings=[]
  healthProbeSettings=[]
  backendPools=[]
  frontendEndpoints=[]
  backendEnforceCertNameCheck=""
  backendSendRecvTimeoutSeconds=""
  tags={}
  outputs={}
  dependsOn=[]]

  [@armResource
    id=id
    name=name
    profile=AZURE_FRONTDOOR_RESOURCE_TYPE
    dependsOn=dependsOn
    tags=tags
    outputs=outputs
    properties={} +
      attributeIfContent("friendlyName", friendlyName) +
      attributeIfContent("routingRules", routingRules) +
      attributeIfContent("loadBalancingSettings", loadBalancingSettings) +
      attributeIfContent("healthProbeSettings", healthProbeSettings) +
      attributeIfContent("backendPools", backendPools) +
      attributeIfContent("frontendEndpoints", frontendEndpoints) +
      attributeIfContent("backendPoolsSettings", {} +
        attributeIfContent("enforceCertificateNameCheck", backendEnforceCertNameCheck) + 
        attributeIfContent("sendRecvTimeoutSeconds", backendSendRecvTimeoutSeconds")
      )
  /]

[/#macro]

[#function getFrontDoorWAFPolicyMatchCondition
  matchVariable
  operator
  matchValue
  selector=""
  negateCondition=False
  transforms=[]]

  [#return 
    {
      "matchVariable": matchVariable,
      "operator": operator,
      "matchValue": matchValue
    } +
    attributeIfContent("selector", selector) +
    attributeIfTrue("negateCondition", negateCondition, negateCondition) +
    attributeIfContent("transforms", transforms)
  ]
[/#function]

[#function getFrontDoorWAFPolicyCustomRule
  priority
  ruleType
  matchConditions
  action
  name=""
  rateLimitDurationInMinutes=""
  rateLimitThreshold=""]

  [#return 
    {
      "priority": priority,
      "ruleType": ruleType,
      "matchConditions": matchConditions,
      "action": action
    } +
    attributeIfContent("name", name) +
    attributeIfContent("rateLimitDurationInMinutes", rateLimitDurationInMinutes) +
    attributeIfContent("rateLimitThreshold", rateLimitThreshold)
  ]
[/#function]

[#function getFrontDoorWAFPolicyManagedRuleSetGroupOverrideObject id action=""]
  [#return 
    { "ruleId": id } +
    attributeIfContent("action", action)]
[/#function]

[#function getFrontDoorWAFPolicyManagedRuleSetGroupOverride name rules=[]]
  [#return 
    { "ruleGroupName": name } + 
    attributeIfContent("rules", rules)]
[/#function]

[#function getFrontDoorWAFPolicyManagedRuleSet type version groupOverrides=[]]
  [#return
    {
      "ruleSetType": type,
      "ruleSetVersion": version
    } +
    attributeIfContent("ruleGroupOverrides", groupOverrides)
  ]
[/#function]

[#function getFrontDoorWAFPolicyManagedRuleSetList rulesets=[]]
  [#return {} + attributeIfContent("managedRuleSets", rulesets)]
[/#function]

[#macro createFrontDoorWAFPolicy
  id
  name
  location=""
  mode=""
  redirectUrl=""
  customBlockResponseStatusCode=""
  customBlockResponseBody=""
  customRules=[]
  managedRules=[]
  tags={}
  outputs={}
  dependsOn=[]]

  [@armResource
    id=id
    name=name
    profile=AZURE_FRONTDOOR_WAF_POLICY_RESOURCE_TYPE
    dependsOn=dependsOn
    properties={} +
      attributeIfContent("customRules", {} +
        attributeIfContent("rules", customRules)
      ) +
      attributeIfContent("managedRules", managedRules) +
      attributeIfContent("policySettings", {} +
        attributeIfContent("mode", mode) +
        attributeIfContent("redirectUrl", redirectUrl) +
        attributeIfContent("customBlockResponseStatusCode", customBlockResponseStatusCode) +
        attributeIfContent("customBlockResponseBody", customBlockResponseBody)
      )
  /]
[/#macro]