[#ftl]

[@addResourceProfile
    service=AZURE_WEB_SERVICE
    resource=AZURE_APP_SERVICE_PLAN_RESOURCE_TYPE
    profile=
        {
            "apiVersion" : "2019-08-01",
            "type" : "Microsoft.Web/serverfarms",
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                }
            }
        }
/]

[@addResourceProfile
    service=AZURE_WEB_SERVICE
    resource=AZURE_WEB_APP_RESOURCE_TYPE
    profile=
        {
            "apiVersion": "2019-08-01",
            "type" : "Microsoft.Web/sites",
            "conditions" : [ "max_length", "globally_unique"],
            "max_name_length" : 60,
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                },
                URL_ATTRIBUTE_TYPE : {
                    "Property" : "properties.defaultHostName"
                }
            }
        }
/]

[#function getAppServicePlanSkuCapability name value="" reason=""]
    [#return 
        {
            "name" : name
        } +
        attributeIfContent("value", value) +
        attributeIfContent("reason", reason)
    ]
[/#function]

[#macro createAppServicePlan
    id
    name
    location
    kind="linux"
    skuName=""
    skuTier=""
    skuSize=""
    skuFamily=""
    skuInstanceCapacity=""
    skuCapacityMin=""
    skuCapacityMax=""
    skuCapacityDefault=""
    skuCapacityScaleType=""
    skuLocations=[]
    skuCapabilities=[]
    workerTier=""
    appServiceEnvironmentId=""
    perSiteScaling=false
    maxElasticWorkerCount=""
    isSpot=false
    spotExpirationTime=""
    freeOfferExpirationTime=""
    reserved=false
    hyperV=false
    targetWorkerCount=""
    targetWorkerSizeId=""
    dependsOn=[]]

    [#local skuCapacity = {} +
        attributeIfContent("minimum", skuCapacityMin) +
        attributeIfContent("maximum", skuCapacityMax) +
        attributeIfContent("default", skuCapacityDefault) +
        attributeIfContent("scaleType", skuCapacityScaleType)
    ]

    [#local sku = {} +
        attributeIfContent("name", skuName) +
        attributeIfContent("tier", skuTier) +
        attributeIfContent("size", skuSize) +
        attributeIfContent("family", skuFamily) +
        attributeIfContent("capacity", skuInstanceCapacity) +
        attributeIfContent("skuCapacity", skuCapacity) +
        attributeIfContent("locations", skuLocations) +
        attributeIfContent("capabilities", skuCapabilities)
    ]

    [@armResource
        id=id
        name=name
        profile=AZURE_APP_SERVICE_PLAN_RESOURCE_TYPE
        location=location
        sku=sku
        dependsOn=dependsOn
        properties={} +
            attributeIfContent("workerTierName", workerTier) +
            attributeIfContent("hostingEnvironmentProfile", 
                appServiceEnvironmentId?has_content?then(
                    getSubResourceReference(appServiceEnvironmentId),
                    ""
                )
            ) +
            attributeIfTrue("perSiteScaling", perSiteScaling, perSiteScaling) +
            numberAttributeIfContent("maximumElasticWorkerCount", maxElasticWorkerCount) +
            attributeIfTrue("isSpot", isSpot, isSpot) +
            attributeIfContent("spotExpirationTime", spotExpirationTime) +
            attributeIfContent("freeOfferExpirationTime", freeOfferExpirationTime) +
            attributeIfTrue("reserved", reserved, reserved) +
            attributeIfTrue("hyperV", hyperV, hyperV) +
            attributeIfContent("targetWorkerCount", targetWorkerCount) +
            attributeIfContent("targetWorkerSizeId", targetWorkerSizeId)
    /]

[/#macro]

[#function getWebAppHostNameSslState
    name=""
    sslState=""
    virtualIP=""
    thumbprint=""
    toUpdate=false
    hostType=""]

    [#return {} +
        attributeIfContent("name", name) +
        attributeIfContent("sslState", sslState) +
        attributeIfContent("virtualIP", virtualIP) +
        attributeIfContent("thumbprint", thumbprint) +
        attributeIfTrue("toUpdate", toUpdate, toUpdate) +
        attributeIfContent("hostType", hostType)
    ]

[/#function]

[#function getWebAppSettingsPair name value]
    [#return
        {
            "name": name,
            "value": value
        }
    ]
[/#function]

[#function getWebAppConnectionString name string type=""]
    [#return
        {
            "name": name,
            "connectionString": string
        } +
        attributeIfContent("type", type)
    ]
[/#function]

[#function getWebAppHandlerSettings extension="" processor="" arguments=""]
    [#return {} +
        attributeIfContent("extension", extension) +
        attributeIfContent("scriptProcessor", processor) +
        attributeIfContent("arguments", arguments)
    ]
[/#function]

[#function getWebAppVirtualDirectory virtualPath="" physicalPath=""]
    [#return {} +
        attributeIfContent("virtualPath", virtualPath) +
        attributeIfContent("physicalPath", physicalPath)
    ]
[/#function]

[#function getWebAppVirtualApplication 
    virtualPath=""
    physicalPath=""
    preloadEnabled=false
    virtualDirectories=[]]

    [#return {} +
        attributeIfContent("virtualPath", virtualPath) +
        attributeIfContent("physicalPath", physicalPath) +
        attributeIfTrue("preloadEnabled", preloadEnabled, preloadEnabled) +
        attributeIfContent("virtualDirectories", virtualDirectories)
    ]

[/#function]

[#function getWebAppRampUpRule
    name=""
    actionHostName=""
    reroutePercentage=""
    changeStep=""
    changeIntervalInMinutes=""
    minReroutePercentage=""
    maxReroutePercentage=""
    changeDecisionCallbackUrl=""]

    [#return {} +
        attributeIfContent("name", name) +
        attributeIfContent("actionHostName", actionHostName) +
        numberAttributeIfContent("reroutePercentage", reroutePercentage) +
        numberAttributeIfContent("changeStep", changeStep) +
        numberAttributeIfContent("changeIntervalInMinutes", changeIntervalInMinutes) +
        numberAttributeIfContent("minReroutePercentage", minReroutePercentage) +
        numberAttributeIfContent("maxReroutePercentage", maxReroutePercentage) +
        attributeIfContent("changeDecisionCallbackUrl", changeDecisionCallbackUrl)
    ]

[/#function]

[#function getWebAppAutoHealRulesStatusCodeTrigger
    status=""
    subStatus=""
    win32Status=""
    count=""
    timeInterval=""]

    [#return {} +
        numberAttributeIfContent("status", status) +
        numberAttributeIfContent("subStatus", subStatus) +
        numberAttributeIfContent("win32Status", win32Status) +
        numberAttributeIfContent("count", count) +
        attributeIfContent("timeInterval", timeInterval)
    ]

[/#function]

[#function getWebAppAutoHealRulesSlowRequestTrigger
    timeTaken=""
    count=""
    timeInterval=""]

    [#return {} +
        attributeIfContent("timeTaken", timeTaken) +
        attributeIfContent("count", count) +
        attributeIfContent("timeInterval", timeInterval)
    ]

[/#function]

[#function getWebAppAutoHealRules
    requestTriggerCount=""
    requestTriggerTimeInterval=""
    provideBytesInKB=""
    statusCodeTriggers=[]
    slowRequestTriggers=[]
    actionType=""
    actionMinProcessExecutionTime=""
    customActionExe=""
    customActionParameters=""]

    [#local requests = {} +
        numberAttributeIfContent("count", requestTriggerCount) +
        attributeIfContent("timeInterval", requestTriggerTimeInterval)
    ]

    [#local triggers = {} +
        numberAttributeIfContent("provideBytesInKB", provideBytesInKB) +
        attributeIfContent("statusCodes", statusCodeTriggers) +
        attributeIfContent("requests", requests) +
        attributeIfContent("slowRequests", slowRequestTriggers)
    ]

    [#local actions = {} +
        attributeIfContent("actionType", actionType) +
        attributeIfContent("minProcessExecutionTime", actionMinProcessExecutionTime) +
        attributeIfContent("customAction", {} +
            attributeIfContent("exe", customActionExe) +
            attributeIfContent("parameters", customActionParameters)
        )
    ]

    [#return {} + 
        attributeIfContent("triggers", triggers) +
        attributeIfContent("actions", actions)
    ]

[/#function]

[#-- Used for both IpSecurityRestriction and scmIpSecurityRestriction objects --]
[#function getWebAppIpSecurityRestriction
    ipAddress=""
    subnetMask=""
    vnetSubnetResourceId=""
    action=""
    tag=""
    priority=""
    name=""
    description=""]

    [#return {} +
        attributeIfContent("ipAddress", ipAddress) +
        attributeIfContent("subnetMask", subnetMask) +
        attributeIfContent("vnetSubnetResourceId", vnetSubnetResourceId) +
        attributeIfContent("action", action) +
        attributeIfContent("tag", tag) +
        numberAttributeIfContent("priority", priority) +
        attributeIfContent("name", name) +
        attributeIfContent("description", description)
    ]

[/#function]

[#macro createWebApp
    id
    name
    location
    kind
    enabled=true
    hostNameSslStates=[]
    serverFarmId=""
    reserved=false
    hyperV=false
    siteConfigNumberofWorkers=""
    siteConfigDefaultDocuments=[]
    siteConfigNetFrameworkVersion=""
    siteConfigPHPVersion=""
    siteConfigPythonVersion=""
    siteConfigNodeVersion=""
    siteConfigLinuxFXVersion=""
    siteConfigWindowsFxVersion=""
    requestTracingEnabled=false
    requestTracingExpirationTime=""
    remoteDebuggingEnabled=false
    remoteDebuggingVersion=""
    httpLoggingEnabled=false
    logsDirectorySizeLimit=""
    detailedErrorLoggingEnabled=false
    publishingUsername=""
    appSettings=[]
    connectionStrings=[]
    handlerMappings=[]
    documentRoot=""
    scmType=""
    use32bitWorkerProcess=false
    webSocketsEnabled=false
    alwaysOn=false
    javaVersion=""
    javaContainer=""
    javaContainerVersion=""
    appCommandLine=""
    managedPipelineMode=""
    virtualApplications=[]
    loadBalancing=""
    rampUpRules=[]
    maxPercentageCpu=""
    maxMemoryInMb=""
    maxDiskSizeInMb=""
    autoHealEnabled=false
    autoHealRules={}
    tracingOptions=""
    vnetName=""
    corsAllowedOrigins=[]
    corsSupportCredentials=false
    pushKind=""
    pushEnabled=false
    pushTagWhitelistJson=""
    pushTagsRequiringAuth=""
    pushDynamicTagsJson=""
    apiDefinitionUrl=""
    apiManagementConfigId=""
    autoSwapSlotName=""
    localMySqlEnabled=false
    managedServiceIdentityId=""
    xManagedServiceIdentityId=""
    ipSecurityRestrictions=[]
    scmIpSecurityRestrictions=[]
    scmIpSecurityRestrictionsUseMain=false
    http20Enabled=false
    minTlsVersion=""
    ftpsState=""
    preWarmedInstanceCount=""
    healthCheckPath=""
    scmSiteAlsoStopped=false
    clientAffinityEnabled=false
    clientCertEnabled=false
    clientCertExclusionPaths=""
    hostNamesDisabled=false
    containerSize=""
    dailyMemoryTimeQuota=""
    cloningCorrelationId=""
    cloningOverwrite=false
    cloningCustomHostNames=false
    cloningSourceControl=false
    cloningSourceWebAppId=""
    cloningSourceWebAppLocation=""
    cloningHostingEnvironment=""
    cloningAppSettingsOverrides={}
    cloningConfigureLoadBalancing=false
    cloningTrafficManagerProfileId=""
    cloningTrafficManagerProfileName=""
    httpsOnly=false
    redundancyMode=""
    identity={}
    dependsOn=[]]

    [#local siteConfig = {} +
        numberAttributeIfContent("numberOfWorkers", siteConfigNumberofWorkers) +
        attributeIfContent("defaultDocuments", siteConfigDefaultDocuments) +
        attributeIfContent("netFrameworkVersion", siteConfigNetFrameworkVersion) +
        attributeIfContent("phpVersion", siteConfigPHPVersion) +
        attributeIfContent("pythonVersion", siteConfigPythonVersion) +
        attributeIfContent("nodeVersion", siteConfigNodeVersion) +
        attributeIfContent("LinuxFXVersion", siteConfigLinuxFXVersion) +
        attributeIfContent("windowsFxVersion", siteConfigWindowsFxVersion) +
        attributeIfTrue("requestTracingEnabled", requestTracingEnabled, requestTracingEnabled) +
        attributeIfContent("requestTracingExpirationTime", requestTracingExpirationTime) +
        attributeIfContent("remoteDebuggingEnabled", remoteDebuggingEnabled) +
        attributeIfContent("remoteDebuggingVersion", remoteDebuggingVersion) +
        attributeIfTrue("httpLoggingEnabled", httpLoggingEnabled, httpLoggingEnabled) +
        numberAttributeIfContent("logsDirectorySizeLimit", logsDirectorySizeLimit) +
        attributeIfTrue("detailedErrorLoggingEnabled", detailedErrorLoggingEnabled, detailedErrorLoggingEnabled) +
        attributeIfContent("publishingUsername", publishingUsername) +
        attributeIfContent("appSettings", appSettings) +
        attributeIfContent("connectionStrings", connectionStrings) +
        attributeIfContent("handlerMappings", handlerMappings) +
        attributeIfContent("documentRoot", documentRoot) +
        attributeIfContent("scmType", scmType) +
        attributeIfTrue("use32bitWorkerProcess", use32bitWorkerProcess, use32bitWorkerProcess) +
        attributeIfTrue("webSocketsEnabled", webSocketsEnabled, webSocketsEnabled) +
        attributeIfTrue("alwaysOn", alwaysOn, alwaysOn) +
        attributeIfContent("javaVersion", javaVersion) +
        attributeIfContent("javaContainer", javaContainer) +
        attributeIfContent("javaContainerVersion", javaContainerVersion) +
        attributeIfContent("appCommandLine", appCommandLine) +
        attributeIfContent("managedPipelineMode", managedPipelineMode) +
        attributeIfContent("virtualApplications", virtualApplications) +
        attributeIfContent("loadBalancing", loadBalancing) +
        attributeIfContent("experiments",
            attributeIfContent("rampUpRules", rampUpRules)
        ) +
        attributeIfContent("limits",
            attributeIfContent("maxPercentageCpu", maxPercentageCpu) +
            attributeIfContent("maxMemoryInMb", maxMemoryInMb) +
            attributeIfContent("maxDiskSizeInMb", maxDiskSizeInMb)
        ) +
        attributeIfTrue("autoHealEnabled", autoHealEnabled, autoHealEnabled) +
        attributeIfContent("autoHealRules", autoHealRules) +
        attributeIfContent("tracingOptions", tracingOptions) +
        attributeIfContent("vnetName", vnetName) +
        attributeIfContent("cors",
            attributeIfContent("allowedOrigins", corsAllowedOrigins) +
            attributeIfTrue("supportCredentials", corsSupportCredentials, corsSupportCredentials)
        ) +
        attributeIfContent("push",
            attributeIfContent("kind", pushKind) +
            attributeIfContent("properties", {} + 
                attributeIfTrue("isPushEnabled", pushEnabled, pushEnabled) +
                attributeIfContent("tagWhitelistJson", pushTagWhitelistJson) +
                attributeIfContent("tagsRequiringAuth", pushTagsRequiringAuth) +
                attributeIfContent("dynamicTagsJson", pushDynamicTagsJson)
            )
        ) +
        attributeIfContent("apiDefinition",
            attributeIfContent("url", apiDefinitionUrl)
        ) +
        attributeIfContent("apiManagementConfig",
            apiManagementConfigId?has_content?then(
                getSubResourceReference(apiManagementConfigId),
                ""
            )
        ) +
        attributeIfContent("autoSwapSlotName", autoSwapSlotName) +
        attributeIfTrue("localMySqlEnabled", localMySqlEnabled, localMySqlEnabled) +
        numberAttributeIfContent("managedServiceIdentityId", managedServiceIdentityId) +
        numberAttributeIfContent("xManagedServiceIdentityId", xManagedServiceIdentityId) +
        attributeIfContent("ipSecurityRestrictions", ipSecurityRestrictions) +
        attributeIfContent("scmIpSecurityRestrictions", scmIpSecurityRestrictions) +
        attributeIfTrue("scmIpSecurityRestrictionsUseMain", scmIpSecurityRestrictionsUseMain, scmIpSecurityRestrictionsUseMain) +
        attributeIfTrue("http20Enabled", http20Enabled, http20Enabled) +
        attributeIfContent("minTlsVersion", minTlsVersion) +
        attributeIfContent("ftpsState", ftpsState) +
        numberAttributeIfContent("preWarmedInstanceCount", preWarmedInstanceCount) +
        attributeIfContent("healthCheckPath", healthCheckPath)
    ]

    [@armResource
        id=id
        name=name
        profile=AZURE_WEB_APP_RESOURCE_TYPE
        kind=kind
        location=location
        identity=identity
        dependsOn=dependsOn
        properties={} +
            attributeIfTrue("enabled", enabled, enabled) +
            attributeIfContent("hostNameSslStates", hostNameSslStates) +
            attributeIfContent("serverFarmId", serverFarmId) +
            attributeIfTrue("reserved", reserved, reserved) +
            attributeIfTrue("hyperV", hyperV, hyperV) +
            attributeIfContent("siteConfig", siteConfig) +
            attributeIfTrue("scmSiteAlsoStopped", scmSiteAlsoStopped, scmSiteAlsoStopped) +
            attributeIfContent("hostingEnvironmentProfile",
                appServiceEnvironmentId?has_content?then(
                    getSubResourceReference(appServiceEnvironmentId),
                    ""
                )
            ) +
            attributeIfTrue("clientAffinityEnabled", clientAffinityEnabled, clientAffinityEnabled) +
            attributeIfTrue("clientCertEnabled", clientAffinityEnabled, clientAffinityEnabled) +
            attributeIfContent("clientCertExclusionPaths", clientCertExclusionPaths) +
            attributeIfTrue("hostNamesDisabled", hostNamesDisabled, hostNamesDisabled) +
            numberAttributeIfContent("containerSize", containerSize) +
            numberAttributeIfContent("dailyMemoryTimeQuota", dailyMemoryTimeQuota) +
            attributeIfContent("cloningInfo",
                attributeIfContent("correlationId", cloningCorrelationId) +
                attributeIfTrue("overwrite", cloningOverwrite, cloningOverwrite) +
                attributeIfTrue("cloneCustomHostNames", cloningCustomHostNames, cloningCustomHostNames) +
                attributeIfTrue("cloneSourceControl", cloningSourceControl, cloningSourceControl) +
                attributeIfContent("sourceWebAppId", cloningSourceWebAppId) +
                attributeIfContent("sourceWebAppLocation", cloningSourceWebAppLocation) +
                attributeIfContent("hostingEnvironment", cloningHostingEnvironment) +
                attributeIfContent("appSettingsOverrides", cloningAppSettingsOverrides) +
                attributeIfTrue("configureLoadBalancing", cloningConfigureLoadBalancing, cloningConfigureLoadBalancing) +
                attributeIfContent("trafficManagerProfileId", cloningTrafficManagerProfileId) +
                attributeIfContent("trafficManagerProfileName", cloningTrafficManagerProfileName)
            ) +
            attributeIfTrue("httpsOnly", httpsOnly, httpsOnly) +
            attributeIfContent("redundancyMode", redundancyMode)
    /]

[/#macro]

[#function getWebAppRunTime language]
[#-- values from here:                                                                   --]
[#-- https://docs.microsoft.com/en-us/azure/azure-functions/functions-versions#languages --]

    [#local runTime = {}]
    
    [#switch language]

        [#case "dotnetcore1.0"]
            [#local runTime +=
                { 
                    "ExtensionVersion": "~1",
                    "WorkerRunTime": "dotnet",
                    "LinuxFXVersion" : "DOTNET|1.0"
                } 
            ]
            [#break]

        [#case "dotnetcore2.1"]
            [#local runTime +=
                { 
                    "ExtensionVersion": "~1",
                    "WorkerRunTime": "dotnet",
                    "LinuxFXVersion" : "DOTNET|2"
                } 
            ]
            [#break]

        [#case "dotnetcore"]
            [#local runTime +=
                { 
                    "ExtensionVersion": "~2",
                    "WorkerRunTime": "dotnet",
                    "LinuxFXVersion" : "DOTNET|2"
                } 
            ]
            [#break]

        [#case "java8"]
            [#local runTime += 
                {
                    "ExtensionVersion" : "~3",
                    "WorkerRunTime" : "java",
                    "LinuxFXVersion" : "NODE"
                }
            ]
            [#break]
            
        [#case "java11"]
            [#local runTime += 
                {
                    "ExtensionVersion" : "~3",
                    "WorkerRunTime" : "java",
                    "LinuxFXVersion" : "node|10"
                }
            ]
            [#break]

        [#case "nodejs"]
            [#local runTime += 
                {
                    "ExtensionVersion" : "~2",
                    "WorkerRunTime" : "node",
                    "LinuxFXVersion" : "node|10",
                    "DefaultVersion" : "10.15.2"
                }
            ]
            [#break]
            
        [#case "nodejs4.3"]
            [#local runTime +=
                {
                    "ExtensionVersion" : "~1",
                    "WorkerRunTime" : "node",
                    "LinuxFXVersion" : "node|10",
                    "DefaultVersion" : language?split("nodejs")[1]
                }
            ]
            [#break]

        [#case "nodejs4.3-edge"]
            [#local runTime +=
                {
                    "ExtensionVersion" : "~1",
                    "WorkerRunTime" : "node",
                    "LinuxFXVersion" : "node|10",
                    "DefaultVersion" : language?split("nodejs")[1]
                }
            ]
            [#break]

        [#case "nodejs6.10"]
            [#local runTime +=
                {
                    "ExtensionVersion" : "~1",
                    "WorkerRunTime" : "node",
                    "LinuxFXVersion" : "node|10",
                    "DefaultVersion" : language?split("nodejs")[1]
                }
            ]
            [#break]

        [#case "nodejs8.10"]
            [#local runTime += 
                {
                    "ExtensionVersion" : "~2",
                    "WorkerRunTime" : "node",
                    "LinuxFXVersion" : "NODE|8",
                    "DefaultVersion" : language?split("nodejs")[1]
                }
            ]
            [#break]

        [#case "python2.7"]
            [#local runTime +=
                {
                    "ExtensionVersion" : "~2",
                    "WorkerRunTime" : "python",
                    "LinuxFXVersion" : "PYTHON|2.7"
                }
            ]
            [#break]

        [#case "python3.6"]
            [#local runTime +=
                {
                    "ExtensionVersion" : "~3",
                    "WorkerRunTime" : "python",
                    "LinuxFXVersion" : "PYTHON|3.6"
                }
            ]
            [#break]

        [#case "python3.7"]
            [#local runTime +=
                {
                    "ExtensionVersion" : "~3",
                    "WorkerRunTime" : "python",
                    "LinuxFXVersion" : "PYTHON|3.7"
                }
            ]
            [#break]

        [#case "python3.8"]
            [#-- 3.8 not available at time of writing https://github.com/Azure-App-Service/python --]
            [#local runTime +=
                {
                    "ExtensionVersion" : "~3",
                    "WorkerRunTime" : "python",
                    "LinuxFXVersion" : "PYTHON|3.7"
                }
            ]
            [#break]

        [#default]
            [@fatal
                message="Unsupported RunTime Language"
                context=language
                enabled=true
            /]
            [#break]
    [/#switch]

    [#return runTime]

[/#function]