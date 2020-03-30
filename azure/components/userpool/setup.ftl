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
    [#local keyvault = baselineAttributes["KEYVAULT_ID"]]

    [#-- Instantiate CLI Args --]
    [#local replyUrls = []]

    [#list occurrence.Occurrences![] as subOccurrence]

        [#local subCore = subOccurrence.Core]
        [#local subSolution = subOccurrence.Configuration.Solution]
        [#local subResources = subOccurrence.State.Resources]

        [#if !subSolution.Enabled]
            [#continue]
        [/#if]

        [#-- Sub Occurrance Link Processing --]
        [#list (subSolution.Links!{})?values?filter(l -> l?is_hash) as link]

            [#local subLinkTarget = getLinkTarget(subOccurrence, link, false)]
            [@debug message="Link Target" context=subLinkTarget enabled=false /]

            [#if !subLinkTarget?has_content]
                [#continue]
            [/#if]

            [#local subLinkTargetCore = subLinkTarget.Core]
            [#local subLinkTargetConfiguration = subLinkTarget.Configuration]
            [#local subLinkTargetResources = subLinkTarget.State.Resources]
            [#local subLinkTargetAttributes = subLinkTarget.State.Attributes]

            [#switch subLinkTargetCore.Type]
                [#case LB_PORT_COMPONENT_TYPE]
                [#case USERPOOL_AUTHPROVIDER_COMPONENT_TYPE]
                    [#break]
                [#case EXTERNALSERVICE_COMPONENT_TYPE]
                        [#if subLinkTargetAttributes["AUTH_CALLBACK_URL"]?has_content ]
                            [#local replyUrls += subLinkTargetAttributes["AUTH_CALLBACK_URL"]?split(",") ]
                        [/#if]
                    [#break]
            [/#switch]

        [/#list]

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
                [#local cliArgs = {
                    "display-name": client.Name
                } +
                    attributeIfContent("id", getExistingReference(client.Id)!"") +
                    attributeIfTrue("oauth2-allow-implicit-flow", flows?seq_contains("implicit"), true) +
                    attributeIfTrue("available-to-other-tenants", otherTenants, otherTenants) +
                    attributeIfContent("reply-urls", replyUrls)
                ]
                
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
                            " case $\{STACK_OPERATION} in",
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
                            "       result=$(az ad app $\{STACK_OPERATION} " + args?join(" ") + ")",
                            "       objectId=$(echo $result | jq .objectId)"
                        ] +
                        generateSecret?then(
                            [
                                "       # Add Certificate as Client Secret",
                                "       az ad app credential reset --create-cert \\",
                                "           --keyvault " + keyvault + " \\",
                                "           --cert " + formatName(client.Name, "appregistration") + " \\",
                                "           --id $\{objectId}"
                            ],
                            []
                        ) +
                        pseudoArmStackOutputScript(
                            "Client Registration",
                            {
                                client.Id : "$\{objectId}"
                            },
                            "client"
                        ) +
                        [
                            "       ;;",
                            "   esac",
                            "       "
                        ]
                /]

            [/#if]

        [/#if]

    [/#list]

[/#macro]