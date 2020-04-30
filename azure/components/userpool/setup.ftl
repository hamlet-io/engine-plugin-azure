[#ftl]

[#macro azure_userpool_arm_generationcontract_solution occurrence]
    [@addDefaultGenerationContract subsets=["prologue"] /]
[/#macro]

[#macro azure_userpool_arm_setup_solution occurrence]
    [@debug message="Entering" context=occurrence enabled=false /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#-- Baseline Links --]
    [#local baselineLinks = getBaselineLinks(occurrence, ["SSHKey"], false, false)]
    [#local baselineAttributes = baselineLinks["SSHKey"].State.Attributes]
    [#local keyvaultId = baselineAttributes["KEYVAULT_ID"]]
    [#local keyvault = getExistingReference(keyvaultId, NAME_ATTRIBUTE_TYPE)]

    [#-- Instantiate CLI Args --]
    [#local replyUrls = []]
    [#local cliArgs = {}]

    [#list occurrence.Occurrences![] as subOccurrence]

        [#local subCore = subOccurrence.Core]
        [#local subSolution = subOccurrence.Configuration.Solution]
        [#local subResources = subOccurrence.State.Resources]
        [#local subAttributes = subOccurrence.State.Attributes]

        [#if !subSolution.Enabled]
            [#continue]
        [/#if]

        [#-- Resource SubComponent Processing --]
        [#if subCore.Type == USERPOOL_RESOURCE_COMPONENT_TYPE]
            
            [#local subLinkTarget = getLinkTarget(subOccurrence, subSolution.Server.Link, false)]

            [#if !subLinkTarget?has_content]
                [#continue]
            [/#if]

            [#local subLinkTargetAttributes = subLinkTarget.State.Attributes]
            [#if ((subLinkTargetAttributes[subSolution.Server.LinkAttribute])!"")?has_content ]
                [#local replyUrls += [subLinkTargetAttributes[subSolution.Server.LinkAttribute]]]
            [#else]
                [@fatal
                    message="Server Link Attribute not found"
                    context=subSolution.Server
                    detail="The LinkAttribute specified could not be found on the provided link"
                /]
            [/#if]

        [/#if]

        [#-- Auth Provider Processing --]
        [#if subCore.Type == USERPOOL_AUTHPROVIDER_COMPONENT_TYPE]
        [/#if]

        [#-- Client Processing --]
        [#if subCore.Type == USERPOOL_CLIENT_COMPONENT_TYPE]

            [#local client = subResources["client"]]

            [#if deploymentSubsetRequired("prologue", false)]

                [#local flows = subSolution.OAuth.Flows![]]
                [#local otherTenants = subSolution.azure\:AllowOtherTenants!false]
                [#local generateSecret = subSolution.ClientGenerateSecret!false]

                [#-- CLI Args in the format {"arg": "value"} --]
                [#-- We can then output all args to the CLI  --]
                [#local cliArgs += {
                    "display-name": client.Name
                } +
                    attributeIfTrue("oauth2-allow-implicit-flow", flows?seq_contains("implicit"), true) +
                    attributeIfTrue("available-to-other-tenants", otherTenants, otherTenants)
                ]
                
            [/#if]

        [/#if]

    [/#list]

    [#local cliArgs += {} + 
        attributeIfContent("reply-urls", replyUrls?join(' '))]

    [#-- Format Args as CLI Parameters --]
    [#local args = []]
    [#list cliArgs as key,value]
        [#if value?is_boolean]
            [#local formattedValue = value?c]
        [#elseif value?is_sequence]
            [#-- all array args on cli command are space-seperated --]
            [#local formattedValue = value?join(" ")]
        [#else]
            [#local formattedValue = value]
        [/#if]

        [#local arg = (key?ensure_starts_with("--")) + " " + formattedValue]
        [#local args += [arg]]
    [/#list]

    [#-- Create App Registration --]
    [@addToDefaultBashScriptOutput
        content=
            [
                " # AAD App Registration",
                " case $\{DEPLOYMENT_OPERATION} in",
                "   delete)"
            ] +
            identifier?has_content?then(
                [
                    "       # Remove AAD App Registration",
                    "       info \"Removing AAD App Registration\"",
                    "       result=$(az ad app delete --id " + identifier + ")",
                    "       ;;"
                ],
                [
                    "       # Remove AAD App Registration",
                    "       info \"No App Registration Identifier Found. Skipping.\"",
                    "       ;;"
                ]
            ) +
            [
                "   create|update)",   
                "       az ad app create " + args?join(" ") + " > $tmp/registration.json",
                "       objectId=$(runJQ -r '.objectId' < $tmp/registration.json)",
                "       clientId=$(runJQ -r '.appId' < $tmp/registration.json)"
            ] +
            generateSecret?then(
                [
                    "       # Add Certificate as Client Secret",
                    "       az ad app credential reset --create-cert \\",
                    "           --keyvault " + keyvault + " \\",
                    "           --cert " + formatName(client.Name, "appregistration") + " \\",
                    "           --id $(echo \"$\{objectId}\") > /dev/null"
                ],
                []
            ) +
            pseudoArmStackOutputScript(
                "Client Registration",
                {
                    client.Id : "$\{objectId}",
                    client.ClientAppId : "$\{clientId}"
                },
                "client"
            ) +
            [
                "       ;;",
                "   esac",
                "       "
            ]
    /]

[/#macro]