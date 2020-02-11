[#ftl]

[#macro azure_lambda_arm_genplan_application occurrence]
    [@addDefaultGenerationPlan subsets=["template", "epilogue"] /]
[/#macro]

[#macro azure_lambda_arm_setup_application occurrence]
    
    [@debug message="Entering Function ARM Setup" context=occurrence enabled=false /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#-- Baseline Links --]
    [#local baselineLinks = getBaselineLinks(occurrence, [ "OpsData"], false, false)]
    [#local baselineAttributes = baselineLinks["OpsData"].State.Attributes]

    [#local storageAccountId = getExistingReference(baselineAttributes["ACCOUNT_ID"], "", "", "", "")]
    [#local storageAccountName = baselineAttributes["ACCOUNT_NAME"]]

    [#list occurrence.Occurrences![] as subOccurrence]

        [#local subCore = subOccurrence.Core]
        [#local subSolution = subOccurrence.Configuration.Solution]
        [#local subResources = subOccurrence.State.Resources]
        [#local function = subResources["function"]]

        [#-- Setting Kind here to make it easier to support Windows functionapps at a later time --]
        [#local functionKind = "functionapp,linux"]

        [#-- App Settings --]
        [#local appSettings = []]
        [#local runTimeSettings = getWebAppRunTime(subSolution.RunTime)]
        
        [#local mandatoryAppSettings = 
            {
                "AzureWebJobsStorage" : formatAzureStorageAccountConnectionStringReference(storageAccountId, storageAccountName, "keys[0].value"),
                "FUNCTIONS_EXTENSION_VERSION" : runTimeSettings.ExtensionVersion,
                "FUNCTIONS_WORKER_RUNTIME" : runTimeSettings.WorkerRunTime,
                "WEBSITE_RUN_FROM_PACKAGE" : 1
            } +
            attributeIfTrue("WEBSITE_NODE_DEFAULT_VERSION", runTimeSettings.DefaultVersion?has_content!false, runTimeSettings.DefaultVersion!"")
        ]
        [#list mandatoryAppSettings as settingName,settingValue]
            [#local appSettings += [getWebAppSettingsPair(settingName, settingValue)]]
        [/#list]

        [#-- create the Function on Consumption plan     --]
        [#-- linux function apps must have reserved=true --]
        [@createWebApp
            id=function.Id
            name=function.Name
            location=regionId
            kind=functionKind
            reserved=true
            appSettings=appSettings
            siteConfigLinuxFXVersion=runTimeSettings.LinuxFXVersion!""
        /]

        [#-- Epilogue - Publish Function --]
        [@addToDefaultBashScriptOutput
            content=
                [#-- copy zip function app locally --]
                getBuildScript(
                    "functionFiles",
                    "lambda",
                    productName,
                    occurrence,
                    "lambda.zip"
                ) +
                [
                    "    info \"$\{DEPLOYMENT_OPERATION} Function App ... \"",
                    "    az_functionapp_deploy" +
                        " \"" + getExistingReference("Subscription") + "\"" +
                        " \"" + getExistingReference("ResourceGroup") + "\"" +
                        " \"" + function.Name + "\"" +
                        " \"" + "$\{functionFiles[0]}" + "\"" +
                        " $\{DEPLOYMENT_OPERATION} || return $?"
                ]
        /]

    [/#list]

[/#macro]
