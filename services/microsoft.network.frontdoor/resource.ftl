[#ftl]

[@addResourceProfile 
  service=AZURE_NETWORK_FRONTDOOR_SERVICE
  resource=AZURE_FRONTDOOR_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-05-01",
      "type" : "Microsoft.Network/frontDoors",
      "conditions" : [ "alphanumeric_only" ],
      "outputMappings" : {
        REFERENCE_ATTRIBUTE_TYPE : {
          "Property" : "id"
        }
      }
    }
/]

[@addResourceProfile 
  service=AZURE_NETWORK_FRONTDOOR_SERVICE
  resource=AZURE_FRONTDOOR_WAF_POLICY_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-03-01",
      "type" : "Microsoft.Network/FrontDoorWebApplicationFirewallPolicies",
      "outputMappings" : {
        REFERENCE_ATTRIBUTE_TYPE : {
          "Property" : "id"
        }
      }
    }
/]

[#function getFrontDoorRoutingRule
  name=""
  frontendEndpoints=[]
  acceptedProtocols=[]
  patternsToMatch=[]
  routeODataType="#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration"
  forwardingProtocol=""
  forwardingBackendPool={}
  forwardingCacheConfig={}
  forwardingCustomPath=""
  routeRedirectType=""
  routeRedirectProtocol=""
  routeCustomHost=""
  routeCustomPath=""
  routeCustomQueryString=""
  routeCustomFragment=""]

  [#switch routeODataType]

    [#case "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration"]
      [#local routeConfig = 
        {
          "@odata.type" : routeODataType,
          "forwardingProtocol" : forwardingProtocol?capitalize?ensure_ends_with("Only"),
          "backendPool" : getSubResourceReference(forwardingBackendPool)
        } +
        attributeIfContent("cacheConfiguration", forwardingCacheConfig) +
        attributeIfContent("customForwardingPath", forwardingCustomPath)
      ]
      [#break]
    [#case "#Microsoft.Azure.FrontDoor.Models.FrontdoorRedirectConfiguration"]
      [#local routeConfig = 
        {
          "@odata.type" : routeODataType,
          "redirectType" : routeRedirectType,
          "redirectProtocol" : routeRedirectProtocol
        } +
        attributeIfContent("customHost", routeCustomHost) +
        attributeIfContent("customPath", routeCustomPath) +
        attributeIfContent("customQueryString", routeCustomQueryString) +
        attributeIfContent("customFragment", routeCustomFragment)
      ]
      [#break]
  [/#switch]

  [#local properties = 
    {
      "routeConfiguration" : routeConfig
    } +
    attributeIfContent("frontendEndpoints", frontendEndpoints) +
    attributeIfContent("acceptedProtocols", acceptedProtocols) +
    attributeIfContent("patternsToMatch", patternsToMatch)
  ]

  [#return
    {
      "name": name,
      "properties" : properties
    }
  ]
[/#function]

[#function getFrontDoorLoadBalancingSettings
  name
  sampleSize=4
  successfulSamplesRequired=2
  additionalLatencyMilliseconds=0]

  [#return
    {
      "name" : name,
      "properties" : {
        "sampleSize" : sampleSize?number,
        "successfulSamplesRequired" : successfulSamplesRequired?number,
        "additionalLatencyMilliseconds" : additionalLatencyMilliseconds?number
      }
    }
  ]
[/#function]

[#function getFrontDoorHealthProbeSettings
  name=""
  path=""
  protocol=""
  intervalInSeconds=""
  healthProbeMethod=""]

  [#return {} +
    attributeIfContent("name", name) +
    attributeIfContent("properties", {} +
      attributeIfContent("path", path) +
      attributeIfContent("protocol", protocol) +
      attributeIfContent("intervalInSeconds", intervalInSeconds?number) +
      attributeIfContent("healthProbeMethod", healthProbeMethod)
    )
  ]
[/#function]

[#function getFrontDoorBackend
  address
  httpPort
  httpsPort
  priority=1
  weight=50
  backendHostHeader=""]

  [#return {} +
    attributeIfContent("address", address) +
    attributeIfContent("httpPort", httpPort?number) +
    attributeIfContent("httpsPort", httpsPort?number) +
    attributeIfContent("priority", priority?number) +
    attributeIfContent("weight", weight?number) +
    attributeIfContent("backendHostHeader", backendHostHeader)
  ]
[/#function]

[#function getFrontDoorBackendPool
  name=""
  backends=[]
  loadBalancingSettings={}
  healthProbeSettings={}]

  [#local properties = 
    {
      "loadBalancingSettings" : loadBalancingSettings
    }  +
    attributeIfContent("backends", backends) +
    attributeIfContent("healthProbeSettings", healthProbeSettings)
  ]

  [#return
    {
      "properties" : properties
    } +
    attributeIfContent("name", name)
  ]
[/#function]

[#function getFrontDoorFrontendEndpoint
  name=""
  hostName=""
  sessionAffinityEnabledState=""
  sessionAffinityTtlSeconds=""
  webApplicationFirewallPolicyLinkId=""]

  [#return {} +
    attributeIfContent("name", name) +
    attributeIfContent("properties", {} +
      attributeIfContent("hostName", hostName) +
      attributeIfContent("sessionAffinityEnabledState", sessionAffinityEnabledState) +
      attributeIfContent("sessionAffinityTtlSeconds", sessionAffinityTtlSeconds?number) +
      attributeIfContent("webApplicationFirewallPolicyLink", {} +
        attributeIfContent("id", webApplicationFirewallPolicyLinkId)
      )
    )
  ]
[/#function]

[#macro createFrontDoor
  id
  name
  location
  friendlyName=""
  routingRules=[]
  loadBalancingSettings=[]
  healthProbeSettings=[]
  backendPools=[]
  frontendEndpoints=[]
  backendEnforceCertNameCheck=""
  backendSendRecvTimeoutSeconds=""
  tags={}
  dependsOn=[]]

  [@armResource
    id=id
    name=name
    profile=AZURE_FRONTDOOR_RESOURCE_TYPE
    location=location
    dependsOn=dependsOn
    tags=tags
    properties={} +
      attributeIfContent("friendlyName", friendlyName) +
      attributeIfContent("routingRules", routingRules) +
      attributeIfContent("loadBalancingSettings", loadBalancingSettings) +
      attributeIfContent("healthProbeSettings", healthProbeSettings) +
      attributeIfContent("backendPools", backendPools) +
      attributeIfContent("frontendEndpoints", frontendEndpoints) +
      attributeIfContent("backendPoolsSettings", {} +
        attributeIfContent("enforceCertificateNameCheck", backendEnforceCertNameCheck) + 
        attributeIfContent("sendRecvTimeoutSeconds", backendSendRecvTimeoutSeconds)
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

[#function getFrontDoorWAFPolicyManagedRuleSet type version exclusions=[] groupOverrides=[]]
  [#return
    {
      "ruleSetType": type,
      "ruleSetVersion": version
    } +
    attributeIfContent("exclusions", exclusions) +
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
  securityProfile={}
  redirectUrl=""
  customBlockResponseStatusCode=""
  customBlockResponseBody=""
  dependsOn=[]]

  [#local mode = securityProfile.Enabled?then("Prevention", "Detection")]
  [#local wafProfile = wafProfiles[securityProfile.WAFProfile]]
  [#local wafValueSet = wafValueSets[securityProfile.WAFValueSet]]
  [#local customRules = []]

  [#-- Custom Rules --]
  [#-- TODO(rossmurr4y): implement custom rules for WAF --]
  [#--[#local wafRules = getWAFProfileRules(
    wafProfile,
    blueprintObject.WAFRuleGroups,
    blueprintObject.WAFRules,
    blueprintObject.WAFConditions)]

  [#list wafRules as rule]

    [#local matchConditions = []]
    
    [#list rule.Conditions as condition]  

      [#if condition?is_hash]
        [#local matchConditions += []]
      [/#if]
    [/#list]

    [#local customRules += [getFrontDoorWAFPolicyCustomRule(
      rule.NameSuffix,
      rule.Action?capitalize,
      "1",
      rule.Conditions[0].Type?ends_with("Match")?then("MatchRule", "RateLimitRule"),
      matchConditions
      ""
      ""
    )]]
  [/#list] --]

  [#-- Azure Managed Rules --]
  [#local managedRules =
    getFrontDoorWAFPolicyManagedRuleSetList([
      getFrontDoorWAFPolicyManagedRuleSet(
        "DefaultRuleSet",
        "1.0"
      )
    ])
  ]

  [@armResource
    id=id
    name=name
    profile=AZURE_FRONTDOOR_WAF_POLICY_RESOURCE_TYPE
    location=location
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