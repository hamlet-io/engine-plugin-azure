[#ftl]

[#macro azure_lambda_arm_deployment_generationcontract occurrence]
    [@addDefaultGenerationContract subsets=["template", "parameters", "epilogue"] /]
[/#macro]

[#macro azure_lambda_arm_deployment occurrence]

    [@debug message="Entering Function ARM Setup" context=occurrence enabled=false /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#-- Baseline Links --]
    [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData", "SSHKey"], false, false)]
    [#local baselineAttributes = baselineLinks["OpsData"].State.Attributes]
    [#local keyAttributes = baselineLinks["SSHKey"].State.Attributes]

    [#local storageKeySecret   = baselineAttributes["STORAGE_KEY_SECRET"]]
    [#local storageAccountName = baselineAttributes["ACCOUNT_NAME"]]
    [#local keyvaultId         = keyAttributes["KEYVAULT_ID"]]

    [#list occurrence.Occurrences![] as subOccurrence]

        [#local subCore = subOccurrence.Core]
        [#local subSolution = subOccurrence.Configuration.Solution]
        [#local subResources = subOccurrence.State.Resources]
        [#local function = subResources["function"]]

        [#local appSettings = []]

        [#local contextLinks = getLinkTargets(subOccurrence)]
        [#local _context =
            {
                "DefaultEnvironment" : defaultEnvironment(subOccurrence, contextLinks, baselineLinks),
                "Environment" : {},
                "ContextSettings" : {},
                "Links" : contextLinks,
                "BaselineLinks" : baselineLinks,
                "DefaultCoreVariables" : false,
                "DefaultEnvironmentVariables" : true,
                "DefaultLinkVariables" : false,
                "DefaultBaselineVariables" : false
            }
        ]

        [#-- Add in extension specifics including override of defaults --]
        [#local _context = invokeExtensions( subOccurrence, _context )]

        [#if deploymentSubsetRequired("parameters", true)]

            [@createKeyVaultParameterLookup
                vaultId=keyvaultId
                secretName=storageKeySecret
            /]

            [#-- Establish Parameter Lookup for any Secrets in final env --]
            [#local secrets = getSettingSecrets(_context.DefaultEnvironment, "")]

            [#list secrets as secret]
                [#list secret?values as secretName]
                    [@createKeyVaultParameterLookup
                        vaultId=keyvaultId
                        secretName=secretName
                    /]
                [/#list]
            [/#list]
        [/#if]

        [#list getFinalEnvironment(occurrence, _context).Environment as key,value]
            [#local appSettings += [getWebAppSettingsPair(key, value)]]
        [/#list]

        [#-- Setting Kind here to make it easier to support Windows functionapps at a later time --]
        [#local functionKind = "functionapp,linux"]

        [#-- App Settings --]
        [#local runTimeSettings = getWebAppRunTime(subSolution.RunTime)]

        [#local mandatoryAppSettings =
            {
                "AzureWebJobsStorage" : formatAzureStorageAccountConnectionStringReference(getParameterReference(storageKeySecret, false), storageAccountName),
                "FUNCTIONS_EXTENSION_VERSION" : runTimeSettings.ExtensionVersion,
                "FUNCTIONS_WORKER_RUNTIME" : runTimeSettings.WorkerRunTime,
                "WEBSITE_RUN_FROM_PACKAGE" : 1
            } +
            attributeIfTrue("WEBSITE_NODE_DEFAULT_VERSION", runTimeSettings.DefaultVersion?has_content!false, runTimeSettings.DefaultVersion!"")
        ]

        [#list mandatoryAppSettings as settingName,settingValue]
            [#local appSettings += [getWebAppSettingsPair(settingName, settingValue)]]
        [/#list]

        [#if deploymentSubsetRequired("lambda", true)]
            [#-- create the Function on Consumption plan     --]
            [#-- linux function apps must have reserved=true --]
            [@createWebApp
                id=function.Id
                name=function.Name
                location=getRegion()
                kind=functionKind
                reserved=true
                appSettings=appSettings
                siteConfigLinuxFXVersion=runTimeSettings.LinuxFXVersion!""
            /]
        [/#if]

        [#if deploymentSubsetRequired("epilogue", false)]
            [#-- Epilogue - Publish Function --]
            [@addToDefaultBashScriptOutput
                content=
                    [#-- copy zip function app locally --]
                    getBuildScript(
                        "functionFiles",
                        "lambda",
                        productName,
                        occurrence,
                        function.Name + ".zip",
                        getReference(function.Id, function.Name, "ResourceGroup")
                    ) +
                    [
                        "    info \"$\{DEPLOYMENT_OPERATION} Function App ... \"",
                        "    az_functionapp_deploy" +
                            " \"" + getReference(function.Id, function.Name, "Subscription") + "\"" +
                            " $\{RESOURCE_GROUP}" +
                            " \"" + function.Name + "\"" +
                            " \"" + "$\{functionFiles[0]}" + "\"" +
                            " $\{DEPLOYMENT_OPERATION} || return $?"
                    ]
            /]
        [/#if]
    [/#list]

[/#macro]
