[#ftl]

[@addResourceProfile
  service=AZURE_NETWORK_APPLICATION_GATEWAY_SERVICE
  resource=AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-09-01",
      "type" : "Microsoft.Network/applicationGateways",
      "outputMappings" : {
        REFERENCE_ATTRIBUTE_TYPE : {
          "Property" : "id"
        }
      }
    }
/]

[#function getAppGatewayIPConfiguration name subnetId]
  [#return {
      "name": name,
      "properties" : {
        "subnet" : getSubResourceReference(subnetId)
      }
  }]
[/#function]

[#function getAppGatewayAuthenticationCertificate name data]
  [#return {
    "name": name,
    "properties" : { "data" : data }
  }]
[/#function]

[#function getAppGatewayTrustedRootCertificate name data="" secretId=""]
  [#return {
      "name": name,
      "properties" : {} +
        attributeIfContent("data", data) +
        attributeIfContent("keyVaultSecretId", secretId)
  }]
[/#function]

[#function getAppGatewaySslCertificate
  name
  keyVaultSecretId=""
  data=""
  dataPwd=""
  publicCertData=""]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfContent("data", data) +
        attributeIfContent("password", dataPwd) +
        attributeIfContent("publicCertData", publicCertData) +
        attributeIfContent("keyVaultSecretId", keyVaultSecretId)
    }
  ]
[/#function]

[#function getAppGatewayFrontendIPConfiguration
  name
  publicIpAddressId=""
  privateIpAddress=""
  privateIpAllocationMethod="Dynamic"
  subnetId=""]

  [#return
    {
      "name": name,
      "properties" : {
        "privateIPAllocationMethod": privateIpAllocationMethod
      } +
        attributeIfContent("privateIPAddress", privateIpAddress) +
        attributeIfTrue("subnet", subnetId?has_content,
          getSubResourceReference(subnetId)) +
        attributeIfTrue("publicIPAddress", publicIpAddressId?has_content,
          getSubResourceReference(publicIpAddressId))
    }
  ]
[/#function]

[#function getAppGatewayFrontendPort name port]
  [#return
    {
      "name" : name,
      "properties": { "port" : port }
    }
  ]
[/#function]

[#function getAppGatewayProbe
  name
  protocol=""
  host=""
  path=""
  interval=""
  timeout=""
  unhealthyThreshold=""
  pickHostNameFromBackendHttpSettings=false
  minServers=""
  matchBody=""
  matchStatusCodes=[]
  port=""]
  [#return
    {
      "name" : name,
      "properties" : {} +
        attributeIfContent("protocol", protocol) +
        attributeIfContent("host", host) +
        attributeIfContent("path", path) +
        attributeIfContent("interval", interval) +
        attributeIfContent("timeout", timeout) +
        attributeIfContent("unhealthyThreshold", unhealthyThreshold) +
        attributeIfTrue("pickHostNameFromBackendHttpSettings",
          pickHostNameFromBackendHttpSettings,
          pickHostNameFromBackendHttpSettings) +
        attributeIfContent("minServers", minServers) +
        attributeIfContent("match", 
          attributeIfContent("body", matchBody) + 
          attributeIfContent("statusCodes", matchStatusCodes)) +
        attributeIfContent("port", port)
    }
  ]
[/#function]

[#function getAppGatewayBackendAddress fqdn="" ip=""]
  [#return {} +
    attributeIfContent("fqdn", fqdn) +
    attributeIfContent("ipAddress", ip)]
[/#function]

[#function getAppGatewayBackendAddressPool
  name
  backendAddresses=[]]

  [#return
    {
      "name" : name,
      "properties" : {
        "backendAddresses" : backendAddresses
      }
    }
  ]
[/#function]

[#function getAppGatewayBackendHttpSettingsCollection
  name
  port=""
  protocol=""
  path=""
  cookieBasedAffinity=false
  requestTimeout=""
  probeId=""
  authenticationCertificates=[]
  trustedRootCertificates=[]
  connectionDrainingEnabled=false
  connectionDrainingTimeoutInSec=""
  hostName=""
  pickHostNameFromBackendAddress=false
  affinityCookieName=""
  probeEnabled=false]

  [#local connectionDraining = {} +
    attributeIfTrue("enabled",
      connectionDrainingEnabled,
      connectionDrainingEnabled) + 
    attributeIfTrue("drainTimeoutInSec",
      connectionDrainingEnabled,
      connectionDrainingTimeoutInSec)]

  [#return
    {
      "name" : name,
      "properties": {} +
        attributeIfContent("port", port) +
        attributeIfContent("protocol", protocol?capitalize) +
        attributeIfTrue("cookieBasedAffinity", cookieBasedAffinity, "Enabled") +
        attributeIfContent("requestTimeout", requestTimeout) +
        attributeIfTrue("probe", probeId?has_content,
          getSubResourceReference(probeId)) +
        attributeIfContent("authenticationCertificates", authenticationCertificates) +
        attributeIfContent("trustedRootCertificates", trustedRootCertificates) +
        attributeIfContent("connectionDraining", connectionDraining) +
        attributeIfContent("hostName", hostName) +
        attributeIfTrue("pickHostNameFromBackendAddress",
          pickHostNameFromBackendAddress,
          pickHostNameFromBackendAddress) +
        attributeIfContent("affinityCookieName", affinityCookieName) +
        attributeIfTrue("probeEnabled", probeEnabled, probeEnabled) +
        attributeIfContent("path", path)
    }
  ]
[/#function]

[#function getAppGatewayHttpListener
  name
  frontendIPConfigurationId=""
  frontendPortId=""
  protocol=""
  hostName=""
  sslCertificateId=""
  requireServerNameIndication=false
  customErrorConfigurations=[]]

  [#-- applicable only to https --]
  [#if ! (protocol?lower_case == "https")]
    [#local requireServerNameIndication = false]
  [/#if]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfTrue("frontendIPConfiguration", frontendIPConfigurationId?has_content,
          getSubResourceReference(frontendIPConfigurationId)) +
        attributeIfTrue("frontendPort", frontendPortId?has_content,
          getSubResourceReference(frontendPortId)) +
        attributeIfContent("protocol", protocol?capitalize) +
        attributeIfContent("hostName", hostName) +
        attributeIfTrue("sslCertificate", sslCertificateId?has_content,
          getSubResourceReference(sslCertificateId)) +
        attributeIfTrue("requireServerNameIndication", requireServerNameIndication, requireServerNameIndication) +
        attributeIfContent("customErrorConfigurations", customErrorConfigurations)
    }
  ]
[/#function]

[#function getAppGatewayPathRules
  name
  paths=[]
  backendAddressPoolId=""
  backendHttpSettingsId=""
  redirectConfigurationId=""
  rewriteRuleSetId=""]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfContent("paths", paths) +
        attributeIfTrue("backendAddressPool", backendAddressPoolId?has_content,
          getSubResourceReference(backendAddressPoolId)) +
        attributeIfTrue("backendHttpSettings", backendHttpSettingsId?has_content,
          getSubResourceReference(backendHttpSettingsId)) +
        attributeIfTrue("redirectConfiguration", redirectConfigurationId?has_content,
          getSubResourceReference(redirectConfigurationId)) +
        attributeIfTrue("rewriteRuleSet", rewriteRuleSetId?has_content,
          getSubResourceReference(rewriteRuleSetId))
    }
  ]
[/#function]

[#function getAppGatewayUrlPathMap
  name
  defaultBackendAddressPoolId={}
  defaultBackendHttpSettingsId={}
  defaultRewriteRulesetId={}
  defaultRedirectConfigurationId={}
  pathrules=[]]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfTrue("defaultBackendAddressPool", defaultBackendAddressPoolId?has_content,
          getSubResourceReference(defaultBackendAddressPoolId)) +
        attributeIfTrue("defaultBackendHttpSettings", defaultBackendHttpSettingsId?has_content,
          getSubResourceReference(defaultBackendHttpSettingsId)) +
        attributeIfTrue("defaultRewriteRuleSet", defaultRewriteRulesetId?has_content,
          getSubResourceReference(defaultRewriteRulesetId)) +
        attributeIfTrue("defaultRedirectConfiguration", defaultRedirectConfigurationId?has_content,
          getSubResourceReference(defaultRedirectConfigurationId)) +
        attributeIfContent("pathRules", pathrules)       
    }
  ]
[/#function]

[#function getAppGatewayRequestRoutingRule
  name
  ruleType=""
  priority=""
  backendAddressPoolId=""
  backendHttpSettingsId=""
  httpListenerId=""
  urlPathMapId=""
  rewriteRuleSetId=""
  redirectConfigurationId=""]

  [#return
    {
      "name": name,
      "properties": {} +
        attributeIfContent("ruleType", ruleType) +
        attributeIfContent("priority", priority) +
        attributeIfTrue("backendAddressPool", backendAddressPoolId?has_content,
          getSubResourceReference(backendAddressPoolId)) +
        attributeIfTrue("backendHttpSettings", backendHttpSettingsId?has_content,
          getSubResourceReference(backendHttpSettingsId)) +
        attributeIfTrue("httpListener", httpListenerId?has_content,
          getSubResourceReference(httpListenerId)) +
        attributeIfTrue("urlPathMap", urlPathMapId?has_content,
          getSubResourceReference(urlPathMapId)) +
        attributeIfTrue("rewriteRuleSet", rewriteRuleSetId?has_content,
          getSubResourceReference(rewriteRuleSetId)) +
        attributeIfTrue("redirectConfiguration", redirectConfigurationId?has_content,
          getSubResourceReference(redirectConfigurationId))
    }
  ]
[/#function]

[#function getAppGatewayRewriteRuleCondition
  variable=""
  pattern=""
  ignoreCase=false
  negate=false]

  [#return {} +
    attributeIfContent("variable", variable) +
    attributeIfContent("pattern", pattern) +
    attributeIfTrue("ignoreCase", ignoreCase, ignoreCase) +
    attributeIfTrue("negate", negate, negate)
  ]
[/#function]

[#function getAppGatewayRewriteRules
  name=""
  ruleSequence=""
  rewriteRuleConditions=[]
  requestHeaderConfigurations=[]
  responseHeaderConfigurations=[]]

  [#return {} +
    attributeIfContent("name", name) +
    attributeIfContent("ruleSequence", ruleSequence) +
    attributeIfContent("conditions", rewriteRuleConditions) +
    attributeIfContent("actionSet",
      attributeIfContent("requestHeaderConfigurations", requestHeaderConfigurations) +
      attributeIfContent("responseHeaderConfigurations", responseHeaderConfigurations))
  ]

[/#function]

[#function getAppGatewayRewriteRuleSet
  name
  rewriteRules=[]]

  [#return
    {
      "name" : name,
      "properties": {
        "rewriteRules" : rewriteRules
      }
    }
  ]
[/#function]

[#function getAppGatewayRedirectConfiguration
  name
  permanentRedirect=false
  targetListenerId=""
  targetUrl=""
  includePath=false
  includeQueryString=false
  requestRoutingRuleIds=[]
  urlPathMapIds=[]
  pathRuleIds=[]]

  [#return
    {
      "name": name,
      "properties": {} +
        attributeIfTrue("redirectType", permanentRedirect, "Permanent") +
        attributeIfContent("targetListener",
          getSubResourceReference(targetListenerId)) +
        attributeIfContent("targetUrl", targetUrl) +
        attributeIfTrue("includePath", includePath, includePath) +
        attributeIfTrue("includeQueryString", includeQueryString, includeQueryString) +
        attributeIfContent("requestRoutingRules",
          [getSubResourceReferences(requestRoutingRuleIds)]) +
        attributeIfContent("urlPathMaps",
          [getSubResourceReferences(urlPathMapIds)]) +
        attributeIfContent("pathRules",
          [getSubResourceReferences(pathRuleIds)])
    }
  ]
[/#function] 

[#function getAppGatewayCustomErrorConfiguration
  statusCode=""
  url=""]

  [#return
    {
      "statusCode": statusCode,
      "customErrorPageUrl": url
    }
  ]
[/#function]

[#macro createApplicationGateway
  id
  name
  location
  skuName=""
  skuTier=""
  skuCapacity=""
  sslPolicyDisabledProtocols=[]
  sslPolicyType=""
  sslPolicyName=""
  sslPolicyCipherSuites=[]
  sslPolicyMinProtocolVersion=""
  gatewayIPConfigurations=[]
  authenticationCertificates=[]
  trustedRootCertificates=[]
  sslCertificates=[]
  frontendIPConfigurations=[]
  frontendPorts=[]
  probes=[]
  backendAddressPools=[]
  backendHttpSettingsCollection=[]
  httpListeners=[]
  urlPathMaps=[]
  requestRoutingRules=[]
  rewriteRuleSets=[]
  redirectConfigurations=[]
  customErrorConfigurations=[]
  wafEnabled=false
  wafMode=""
  wafRuleSetType=""
  wafRuleSetVersion=""
  wafDisabledRuleGroups=[]
  wafRequestBodyCheck=false
  wafMaxRequestBodySizeInKb=""
  wafFileUploadLimitInMb=""
  wafExclusions=[]
  firewallPolicyId=""
  enableHttp2=false
  enableFips=false
  autoScaleMinCapacity=""
  autoScaleMaxCapacity=""
  identity={}
  dependsOn=[]]

  [#local sku = {} +
    attributeIfContent("name", skuName) +
    attributeIfContent("tier", skuTier) +
    attributeIfContent("capacity", skuCapacity?number)]

  [#local sslPolicy = {} +
    attributeIfContent("disabledSslProtocols", sslPolicyDisabledProtocols) +
    attributeIfContent("policyType", sslPolicyType) +
    attributeIfContent("policyName", sslPolicyName) +
    attributeIfContent("cipherSuites", sslPolicyCipherSuites) +
    attributeIfContent("minProtocolVersion", sslPolicyMinProtocolVersion)]

  [#local wafConfiguration = {}]
  [#if wafEnabled]
    [#local wafConfiguration += {
      "enabled": wafEnabled,
      "firewallMode": wafMode,
      "ruleSetType": wafRuleSetType,
      "ruleSetVersion": wafRuleSetVersion
    } +
    attributeIfContent("disabledRuleGroups", wafDisabledRuleGroups) +
    attributeIfTrue("requestBodyCheck", wafRequestBodyCheck, wafRequestBodyCheck) +
    attributeIfContent("maxRequestBodySizeInKb", wafMaxRequestBodySizeInKb) +
    attributeIfContent("fileUploadLimitInMb", wafFileUploadLimitInMb) +
    attributeIfContent("exclusions", wafExclusions)]
  [/#if]

  [@armResource
    id=id
    name=name
    profile=AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE
    location=location
    identity=identity
    properties=
      {} +
      attributeIfContent("sku", sku) +
      attributeIfContent("sslPolicy", sslPolicy) +
      attributeIfContent("gatewayIPConfigurations", gatewayIPConfigurations) +
      attributeIfContent("authenticationCertificates", authenticationCertificates) +
      attributeIfContent("trustedRootCertificates", trustedRootCertificates) +
      attributeIfContent("sslCertificates", sslCertificates) +
      attributeIfContent("frontendIPConfigurations", frontendIPConfigurations) +
      attributeIfContent("frontendPorts", frontendPorts) +
      attributeIfContent("probes", probes) +
      attributeIfContent("backendAddressPools", backendAddressPools) +
      attributeIfContent("backendHttpSettingsCollection", backendHttpSettingsCollection) +
      attributeIfContent("httpListeners", httpListeners) +
      attributeIfContent("urlPathMaps", urlPathMaps) +
      attributeIfContent("requestRoutingRules", requestRoutingRules) +
      attributeIfContent("rewriteRuleSets", rewriteRuleSets) +
      attributeIfContent("redirectConfigurations", redirectConfigurations) +
      attributeIfContent("webApplicationFirewallConfiguration", wafConfiguration) +
      attributeIfTrue("firewallPolicy", firewallPolicyId?has_content, getSubResourceReference(firewallPolicyId)) +
      attributeIfTrue("enableHttp2", enableHttp2, enableHttp2) +
      attributeIfTrue("enableFips", enableFips, enableFips) +
      attributeIfContent("autoscaleConfiguration", {} +
        attributeIfContent("minCapacity", autoScaleMinCapacity) +
        attributeIfContent("maxCapacity", autoScaleMaxCapacity)) +
      attributeIfContent("customErrorConfigurations", customErrorConfigurations)
    dependsOn=dependsOn
  /]

[/#macro]