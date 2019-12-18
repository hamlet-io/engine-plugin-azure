[#ftl]

[@addResourceProfile
  service=AZURE_NETWORK_APPLICATION_GATEWAY_SERVICE
  resource=AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-09-01",
      "type" : "Microsoft.Network/applicationGateways"
    }
/]

[@addOutputMapping
  provider=AZURE_PROVIDER
  resourceType=AZURE_APPLICATION_GATEWAY_RESOURCE_TYPE
  mappings=
    {
      REFERENCE_ATTRIBUTE_TYPE : {
        "Property" : "id"
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
  data=""
  dataPwd=""
  publicCertData=""
  keyVaultSecretId=""]

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
  privateIpAddress=""
  privateIpAllocationMethod="Static"
  subnetId=""
  publicIpAddressId=""]

  [#return
    {
      "name": name,
      "properties" : {
        "privateIPAllocationMethod": privateIpAllocationMethod
      } +
        attributeIfContent("privateIPAddress", privateIpAddress) +
        attributeIfContent("subnet",
          getSubResourceReference(subnetId)) +
        attributeIfContent("publicIPAddress",
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

[#function getAppGatewayBackendAddressPool
  name
  ipConfigurations=[]
  backendAddresses=[]]

  [#local backendIpAddresses = []]
  [#list backendAddresses as ipAddress]
    [#local backendIpAddresses += [{"ipAddress": ipAddress}]]
  [/#list]

  [#return
    {
      "name" : name,
      "properties" : {} +
        attributeIfContent("backendIPConfigurations", ipConfigurations) +
        attributeIfContent("backendAddresses", backendIpAddresses)
    }
  ]
[/#function]

[#function getAppGatewayBackendHttpSettingsCollection
  name
  port=""
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
  probeEnabled=false
  path=""]

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
        attributeIfContent("protocol", protocol) +
        attributeIfTrue("cookieBasedAffinity", cookieBasedAffinity, "Enabled") +
        attributeIfContent("requestTimeout", requestTimeout) +
        attributeIfContent("probe", 
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
  [#local serverNameIndication = ""]
  [#if protocol?lower_case == "https"]
    [#local serverNameIndication = requireServerNameIndication]
  [/#if]

  [#return
    {
      "name": name,
      "properties" : {} +
        attributeIfContent("frontendIPConfiguration", 
          getSubResourceReference(frontendIPConfigurationId)) +
        attributeIfContent("frontendPort", 
          getSubResourceReference(frontendPortId)) +
        attributeIfContent("protocol", protocol) +
        attributeIfContent("hostName", hostName) +
        attributeIfContent("sslCertificate", 
          getSubResourceReference(sslCertificateId)) +
        attributeIfContent("requireServerNameIndication", serverNameIndication) +
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
        attributeIfContent("backendAddressPool",
          getSubResourceReference(backendAddressPoolId)) +
        attributeIfContent("backendHttpSettings",
          getSubResourceReference(backendHttpSettingsId)) +
        attributeIfContent("redirectConfiguration",
          getSubResourceReference(redirectConfigurationId)) +
        attributeIfContent("rewriteRuleSet",
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
        attributeIfContent("defaultBackendAddressPool", 
          getSubResourceReference(defaultBackendAddressPoolId)) +
        attributeIfContent("defaultBackendHttpSettings", 
          getSubResourceReference(defaultBackendHttpSettingsId)) +
        attributeIfContent("defaultRewriteRuleSet", 
          getSubResourceReference(defaultRewriteRulesetId)) +
        attributeIfContent("defaultRedirectConfiguration",
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
        attributeIfContent("backendAddressPool",
          getSubResourceReference(backendAddressPoolId)) +
        attributeIfContent("backendHttpSettings",
          getSubResourceReference(backendHttpSettingsId)) +
        attributeIfContent("httpListener",
          getSubResourceReference(httpListenerId)) +
        attributeIfContent("urlPathMap",
          getSubResourceReference(urlPathMapId)) +
        attributeIfContent("rewriteRuleSet",
          getSubResourceReference(rewriteRuleSetId)) +
        attributeIfContent("redirectConfiguration",
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
  redirectType=""
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
        attributeIfContent("redirectType", redirectType) +
        attributeIfContent("targetListener",
          getSubResourceReferences(targetListenerId)) +
        attributeIfContent("targetUrl", targetUrl) +
        attributeIfTrue("includePath", includePath, includePath) +
        attributeIfTrue("includeQueryString", includeQueryString, includeQueryString) +
        attributeIfContent("requestRoutingRules",
          getSubResourceReferences(requestRoutingRuleIds)) +
        attributeIfContent("urlPathMaps",
          getSubResourceReferences(urlPathMapIds)) +
        attributeIfContent("pathRules",
          getSubResourceReferences(pathRuleIds))
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
  outputs={}
  dependsOn=[]]

  [#local sku = {} +
    attributeIfContent("name", skuName) +
    attributeIfContent("tier", skuTier) +
    attributeIfContent("capacity", skuCapacity)]

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
      attributeIfContent("firewallPolicy", getSubResourceReference(firewallPolicyId)) +
      attributeIfTrue("enableHttp2", enableHttp2, enableHttp2) +
      attributeIfTrue("enableFips", enableFips, enableFips) +
      attributeIfContent("autoscaleConfiguration", {} +
        attributeIfTrue("minCapacity", autoScaleMinCapacity) +
        attributeIfTrue("maxCapacity", autoScaleMaxCapacity)) +
      attributeIfContent("customErrorConfigurations", customErrorConfigurations)
    outputs=outputs
    dependsOn=dependsOn
  /]

[/#macro]