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
      },
      "global" : true
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

[@addPseudoResourceProfile
    service=AZURE_NETWORK_FRONTDOOR_SERVICE
    resource=AZURE_FRONTDOOR_ROUTE_RESOURCE_TYPE
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
      numberAttributeIfContent("intervalInSeconds", intervalInSeconds) +
      attributeIfContent("healthProbeMethod", healthProbeMethod)
    )
  ]
[/#function]

[#function getFrontDoorBackend
  address
  backendHostHeader=""
  httpPort=""
  httpsPort=""
  priority=1
  weight=50]

  [#if !(backendHostHeader?has_content)]
    [#local backendHostHeader = address]
  [/#if]

  [#return 
    {
      "address" : address,
      "backendHostHeader", backendHostHeader
    } +
    numberAttributeIfContent("httpPort", httpPort) +
    numberAttributeIfContent("httpsPort", httpsPort) +
    numberAttributeIfContent("priority", priority) +
    numberAttributeIfContent("weight", weight)
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
      numberAttributeIfContent("sessionAffinityTtlSeconds", sessionAffinityTtlSeconds) +
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

[#function formatAzureWAFCustomRule priority rule valueSet={}]

    [#local name = rule.NameSuffix?split("-")?map(n -> n?capitalize)?join("")]
    [#local ruleType = rule.Conditions[0].Type]

    [#local conditions = asFlattenedArray(rule.Conditions
      ?map(c -> getAzureWAFConditions(ruleType, c.Filters, valueSet, c.Negated!false)))]

    [#-- Rate Limit Processing --]
    [#local rateLimitConditions = conditions
      ?filter(c -> c.RuleType == "RateLimitRule")]

    [#local ruleTypeAzure = rateLimitConditions
      ?has_content
      ?then("RateLimitRule", "MatchRule")]

    [#local rateLimitConfig = {}]
    [#if rateLimitConditions?has_content]
      [#local rateLimitConfig = rateLimitConditions
        ?filter(c.RateLimit)]
    [/#if]

    [#return {
      "name" : name,
      "priority" : priority,
      "ruleType" : ruleTypeAzure,
      "matchConditions" : conditions?map(c -> c.MatchCondition),
      "action" : rule.Action?capitalize} +
        attributeIfContent("rateLimitThreshold", rateLimitConfig)]
[/#function]

[#function getAzureWAFConditions type filters=[] valueSet={} negated=false]

  [#local conditions = []]
  [#if (WAFConditions[type].ResourceType)?has_content]
    [#list filters
      ?filter(f -> f?is_hash) as filter]

      [#local matchValues = filters?filter(f -> f?is_string)]

      [#switch type]
        [#case AWS_WAF_SQL_INJECTION_MATCH_CONDITION_TYPE]
          [#--[#local conditions += formatAzWAFSqlInjectionMatchCondition(filter, valueSet, negated)]--]
          [#break]
        [#case AWS_WAF_XSS_MATCH_CONDITION_TYPE]
          [#--[#local conditions += formatAzWAFXssMatchCondition(filter, valueSet, negated)]--]
          [#break]
        [#case AWS_WAF_IP_MATCH_CONDITION_TYPE]
          [#local conditions += formatAzWAFIPMatchCondition(
            [{"Targets" : "ips"}],
            {"ips" : asFlattenedArray(matchValues) },
            negated)]
          [#break]
        [#case AWS_WAF_GEO_MATCH_CONDITION_TYPE]
          [#local conditions += formatAzWAFGeoMatchCondition(
            [{"Targets" : "countrycodes"}],
            {"countrycodes" : asFlattenedArray(matchValues) },
            negated)]
          [#break]
        [#case AWS_WAF_BYTE_MATCH_CONDITION_TYPE]
          [#local conditions += formatAzWAFByteMatchCondition(filter, valueSet, negated)]
          [#break]
        [#case AWS_WAF_SIZE_CONSTRAINT_CONDITION_TYPE]
          [#local conditions += formatAzWAFSizeConstraint(filter, valueSet, negated)]
          [#break]
      [/#switch]
    [/#list]
  [/#if]
  [#return conditions]
[/#function]

[#-- Translate Hamlet values into ARM --]
[#function formatAzureMatchValues fields]
  [#local uniqueFieldTypes = 
    getUniqueArrayElements(fields?map(f -> f.Type))]

  [#local uniqueFieldValues =
    getUniqueArrayElements(fields
      ?filter(f -> (f.Data!"")?has_content)
      ?map(f -> f.Data))]

  [#return {
    "Variables" : uniqueFieldTypes,
    "Values" : uniqueFieldValues }]
[/#function]

[#function formatAzureTransform transform]
  [#-- Empty items are not supported --]
  [#local dict = {
    "NONE" : "",
    "CMD_LINE" : "",
    "COMPRESS_WHITE_SPACE" : "Trim",
    "URL_DECODE" : "UrlDecode",
    "LOWERCASE" : "Lowercase",
    "HTML_ENTITY_DECODE" : ""}]
  [#return dict[transform]!""]
[/#function]

[#function getAzureOperator operator]
  [#local dict = {
    "EQ" : "Equal",
    "NE" : "NotEqual",
    "LE" : "LessThanOrEqual",
    "LT" : "LessThan",
    "GE" : "GreaterThanOrEqual",
    "GT" : "GreaterThan",
    "STARTS_WITH" : "BeginsWith",
    "ENDS_WITH" : "EndsWith"}]
  [#return dict[operator]!operator ]
[/#function]

[#function getFrontDoorWAFPolicyManagedRuleSetGroupOverrideObject id action=""]
  [#return { "ruleId": id } +
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
  securityProfile
  enforceOWASP=false
  location=regionId
  dependsOn=[]]

  [#local mode = "Detection"]
  [#if securityProfile.Enabled]
    [#local mode = "Prevention"]
  [/#if]

  [#local wafProfile = wafProfiles[securityProfile.WAFProfile]]
  [#local wafValueSet = wafValueSets[securityProfile.WAFValueSet]]

  [#-- Azure Managed Rules       --]
  [#-- This applies OWASP Top 10 --]
  [#local managedRules = []]
  [#if enforceOWASP]
    [#local managedRules =
      getFrontDoorWAFPolicyManagedRuleSetList([
        getFrontDoorWAFPolicyManagedRuleSet(
          "DefaultRuleSet",
          "1.0",
          [],
          [])])]
  [/#if]

  [#-- Custom Rules --]
  [#local customAzureRules = []]
  [#local customWafRules =
    getWAFProfileRules(wafProfile, wafRuleGroups, wafRules, wafConditions)]

  [#local priority = 1]
  [#list customWafRules as rule]
    [#local customAzureRules += [
      formatAzureWAFCustomRule(priority, rule, wafValueSet)]]
    [#local priority += 100]
  [/#list]

  [@armResource
    id=id
    name=name
    profile=AZURE_FRONTDOOR_WAF_POLICY_RESOURCE_TYPE
    location=location
    dependsOn=dependsOn
    properties={} +
      attributeIfContent("customRules", {} +
        attributeIfContent("rules", customAzureRules)
      ) +
      attributeIfContent("managedRules", managedRules) +
      attributeIfContent("policySettings", {} +
        attributeIfContent("mode", mode) +
        attributeIfContent("redirectUrl", "") +
        attributeIfContent("customBlockResponseStatusCode", "") +
        attributeIfContent("customBlockResponseBody", "")
      )
  /]
[/#macro]

[#function formatAzureWAFMatchCondition
  variable
  operator
  value
  negated=false
  transforms=[]
  selector=""]

  [#local azTransforms = 
    getWAFValueList(transforms, valueSet)
      ?map(t -> formatAzureTransform(t))
      ?filter(t -> t?has_content)]

  [#local azureWAFMatch = formatAzureWAFMatchVariable(variable)]

  [#return {
    "RuleType" : azureWAFMatch.RuleType,
    "MatchCondition" : {
      "matchVariable" : azureWAFMatch.Variable,
      "operator" : getAzureOperator(operator),
      "matchValue" : asFlattenedArray(value)
        ?map(v -> asString(v, ""))
    } +
      attributeIfContent("selector", selector) +
      attributeIfTrue("negateCondition", negated, negated) +
      attributeIfContent("transforms", azTransforms)
  } +
    attributeIfTrue(
      "RateLimit",
      (azureWAFMatch.RuleType == "RateLimitRule"),
      {
        "Threshold" : value
      })
  ]

[/#function]

[#function formatAzureWAFMatchVariable type]

  [#local t = type?lower_case]
  [#local result = {
    "RuleType" : "",
    "Variable" : ""
  }]

  [#switch true]

    [#case t?starts_with("badcookie")]
    [#case t?ends_with("cookies")]
    [#case t?ends_with("cookie")]
      [#local result = mergeObjects(result, {"Variable" : "Cookies"})]
      [#break]

    [#case t?starts_with("query")]
    [#case t?ends_with("query")]
    [#case t?starts_with("sql")]
      [#local result = mergeObjects(result, {"Variable" : "QueryString"})]
      [#break]

    [#case t?ends_with("ips")]
    [#case t?ends_with("countrycodes")]
      [#local result = mergeObjects(result, {"Variable" : "RemoteAddr"})]
      [#break]

    [#case t?ends_with("body")]
      [#local result = mergeObjects(result, {"Variable" : "RequestBody"})]
      [#break]

    [#case t?ends_with("headers")]
    [#case t?ends_with("header")]
      [#local result = mergeObjects(result,
        {
          "Variable" : "RequestHeader"
        })]
      [#break]

    [#case t?ends_with("uri")]
    [#case t?starts_with("uri")]
    [#case type?starts_with("badtokens")]
    [#case type?ends_with("tokens")]
      [#local result = mergeObjects(result, {"Variable" : "RequestUri"})]
      [#break]
      
    [#default]
      [@fatal
        message="WAF Match RuleType could not be determined."
        context={ "Type" : type } 
      /]
      [#break]
  [/#switch]

  [#-- Rule Types --]
  [#switch true]

    [#case type?ends_with("paths")]
    [#case type?starts_with("admin")]
    [#case type?starts_with("login")]
      [#local result = mergeObjects(result, {"RuleType" : "RateLimitRule"})]
      [#break]

    [#default]
      [#local result = mergeObjects(result, {"RuleType" : "MatchRule"})]
      [#break]

  [/#switch]

  [#return result]
[/#function]

[#function formatAzWAFByteMatchCondition filter={} valueSet={} negated=false]
  [#local result = [] ]
  [#list getWAFValueList(filter.FieldsToMatch, valueSet) as match]
    [#list getWAFValueList(filter.Constraints, valueSet) as constraint]
                  
      [#local result += [
        formatAzureWAFMatchCondition(
          match.Type,
          constraint,
          getWAFValueList(filter.Targets, valueSet)![],
          negated,
          transformations,
          match.Data!"")]]

    [/#list]
  [/#list]
  [#return result]
[/#function]

[#function formatAzWAFIPMatchCondition filter={} valueSet={} negated=false]
  [#local result= [] ]
    [#local result += [
      formatAzureWAFMatchCondition(
        "ips",
        "IPMatch",
        getWAFValueList(filter.Targets, valueSet)![], 
        negated)]]
  [#return result]
[/#function]

[#function formatAzWAFGeoMatchCondition filter={} valueSet={} negated=false]
  [#return [
    formatAzureWAFMatchCondition(
      "countrycodes",
      "GeoMatch",
      getWAFValueList(filter.Targets, valueSet)![],
      negated)]]
[/#function]

[#function formatAzWAFSizeConstraint filter={} valueSet={} negated=false]
  [#local result = []]
  [#local sizes = getWAFValueList(filter.Sizes, valueSet)]
  
  [#list sizes as size]
    [#list getWAFValueList(filter.FieldsToMatch, valueSet) as match]
      [#list getWAFValueList(filter.Operators, valueSet) as operator]

        [#local result += [
          formatAzureWAFMatchCondition(
            match.Type,
            operator,
            size,
            negated,
            filter.Transformations,
            match.Data!"")]]

      [/#list]
    [/#list]
  [/#list]
  [#return result]
[/#function]

[#function formatAzWAFSqlInjectionMatchCondition filter={} valueSet={} negated=false]
  [#local result = [] ]
  [#list getWAFValueList(filter.FieldsToMatch, valueSet) as match]

      [#local result += [
        formatAzureWAFMatchCondition(
          match.Type,
          "Contains",
          [],
          negated,
          filter.Transformations,
          match.Data!"")]]

  [/#list]
  [#return result]
[/#function]

[#function formatAzWAFXssMatchCondition filter={} valueSet={} negated=false]
  [#local result = [] ]
  [#list getWAFValueList(filter.FieldsToMatch, valueSet) as match]
    
    [#local result += [
      formatAzureWAFMatchCondition(
        match.Type,
        "Contains",
        [],
        negated,
        filter.Transformations,
        match.Data!"")]]

  [/#list]
  [#return result]
[/#function]