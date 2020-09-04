[#ftl]

[#macro azure_ecs_arm_generationcontract_application occurrence]
    [@addDefaultGenerationContract subsets=["template"] /]
[/#macro]

[#macro azure_ecs_arm_setup_application occurrence]

    [@debug message="Entering Function ARM Setup" context=occurrence enabled=false /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#-- resources --]
    [#local host = resources["plan"]!{}]

    [#-- Baseline Component Lookup 
    [#local baselineLinks = getBaselineLinks(occurrence, ["SSHKey"], false, false)]
    [#local baselineAttributes = baselineLinks["SSHKey"].State.Attributes]
    [#local baselineResources = baselineLinks["SSHKey"].State.Resources]
    [#local sshKey = baselineResources["vmKeyPair"]]
    [#local sshPublicKeyParameterName = sshKey.Name + "PublicKey"]--]

    [#list occurrence.Occurrences![] as subOccurrence]

        [#local subCore = subOccurrence.Core]
        [#local subSolution = subOccurrence.Configuration.Solution]
        [#local subResources = subOccurrence.State.Resources]

        [#switch subCore.Type]

            [#-- Services --]
            [#case ECS_SERVICE_COMPONENT_TYPE]

                [#break]

            [#-- Tasks --]
            [#case ECS_TASK_COMPONENT_TYPE]

                [#break]

        [/#switch]

    [/#list]

    [#-- Container Host --]
    



[/#macro]