[#ftl]

[#macro azure_spa_arm_deployment_generationcontract occurrence]
  [@addDefaultGenerationContract subsets=["prologue", "config", "template", "epilogue"] /]
[/#macro]

[#macro azure_spa_arm_deployment occurrence]

  [@debug message="Entering SPA Setup" context=occurrence enabled=false /]

  [#local core = occurrence.Core ]
  [#local solution = occurrence.Configuration.Solution ]
  [#local settings = occurrence.Configuration.Settings ]
  [#local attributes = occurrence.State.Attributes]
  [#local resources = occurrence.State.Resources]
  [#local profiles = solution.Profiles!{} ]

  [#-- resources --]
  [#local storageAccount = resources["storageAccount"] ]
  [#local blob           = resources["blobService"] ]
  [#local container      = resources["container"] ]

  [#local storageProfile = getStorage(occurrence, "storageAccount", solution.Profiles["azure:Storage"])]
  [#local forwardingPath = attributes["FORWARDING_PATH"]?remove_beginning("/")]
  [#local corsBehaviours = solution["azure:CORSBehaviours"]![] ]
  [#local policyProfile = getPolicyProfile(profiles.Policy, getCLODeploymentMode()) ]

  [#-- links --]
  [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData"], false, false)]
  [#local contextLinks = getLinkTargets(occurrence)]

  [#local distributions = []]

  [#-- SPA Context --]
  [#local _context =
    {
      "DefaultEnvironment" : defaultEnvironment(occurrence, contextLinks, baselineLinks),
      "Environment" : {},
      "Links" : contextLinks,
      "BaselineLinks" : baselineLinks,
      "DefaultCoreVariables" : false,
      "DefaultEnvironmentVariables" : false,
      "DefaultLinkVariables" : false,
      "DefaultBaselineVariables" : false
    }
  ]

  [#-- Add in extension specifics including override of defaults --]
  [#local _context = invokeExtensions(occurrence, _context )]

  [#local _context += getFinalEnvironment(occurrence, _context)]

  [#list _context.Links as id,linkTarget]

    [#local linkTargetCore = linkTarget.Core]
    [#local linkTargetConfiguration = linkTarget.Configuration]
    [#local linkTargetResources = linkTarget.State.Resources]
    [#local linkTargetAttributes = linkTarget.State.Attributes]
    [#local linkDirection = linkTarget.Direction]

    [#switch linkTargetCore.Type]
      [#case CDN_ROUTE_COMPONENT_TYPE]
        [#if linkDirection == "inbound"]
          [#local distributions += [ {
            "DistributionId" : linkTargetAttributes["DISTRIBUTION_ID"],
            "PathPattern" : linkTargetResources["origin"].PathPattern
          }]]
        [/#if]
        [#break]
    [/#switch]

  [/#list]

  [#if deploymentSubsetRequired("prologue", false)]
    [#--
      Prologue Script Order of Operations:
      1 - Stage the latest build files
      2 - Unzip/Sync build files with the container
      3 - Stage the latest config
      4 - Sync config with the container
    --]
    [@addToDefaultBashScriptOutput
      content=
        getBuildScript(
          "spaFiles",
          "spa",
          productName,
          occurrence,
          "spa.zip"
        ) +
        getLocalFileScript(
          "configFiles",
          "$\{CONFIG}",
          "config.json"
        )
    /]
  [/#if]

  [#-- template resources --]
  [@createStorageAccount
    id=storageAccount.Id
    name=storageAccount.Name
    kind=storageProfile.Type
    sku=getStorageSku(storageProfile.Tier, storageProfile.Replication)
    location=getRegion()
    networkAcls=getNetworkAcls("Allow", [], [], "AzureServices")
    accessTier=(storageProfile.AccessTier)!{}
    isHnsEnabled=(storageProfile.HnsEnabled)!false
  /]

  [@createBlobService
    id=blob.Id
    name=blob.Name
    CORSBehaviours=corsBehaviours
    dependsOn=[storageAccount.Reference]
  /]

  [@createBlobServiceContainer
    id=container.Id
    name=container.Name
    publicAccess="Container"
    dependsOn=[
      storageAccount.Reference,
      blob.Reference
    ]
  /]

  [#if deploymentSubsetRequired("config", false)]
    [@addToDefaultJsonOutput
      content={ "RUN_ID" : getCLORunId() } + _context.Environment
    /]
  [/#if]

  [#-- Static Website Hosting can only be enabled in the CLI --]
  [#-- It is applied to an entire Blob Service.              --]
  [#if deploymentSubsetRequired("epilogue", false)]
    [@addToDefaultBashScriptOutput
      content=[
        r"if [[ ! ${DEPLOYMENT_OPERATION} == delete ]]; then",
        "    CONNECTION_STRING=$(az_get_storage_connection_string \"${storageAccount.Name}\")",
        "   az storage blob service-properties update --connection-string \"" + r"${CONNECTION_STRING}" + "\" --static-website true"
        "fi"
      ] +
      syncFilesToBlobContainerScript(
        "spaFiles",
        storageAccount.Name,
        r'\$web',
        forwardingPath
      ) +
      syncFilesToBlobContainerScript(
        "configFiles",
        storageAccount.Name,
        r'\$web',
        formatRelativePath(
          getOccurrenceSettingValue(occurrence, "SETTINGS_PREFIX"),
          solution.ConfigPath
        )
      )
    /]
  [/#if]
[/#macro]
