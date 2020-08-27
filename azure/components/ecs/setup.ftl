[#ftl]

[#macro azure_ecs_arm_generationcontract_application occurrence]
    [@addDefaultGenerationContract subsets=["template"] /]
[/#macro]

[#macro azure_ecs_arm_setup_application occurrence]

    [@debug message="Entering Function ARM Setup" context=occurrence enabled=true /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#-- resources --]
    [#local cluster = resources["cluster"]]

    [#local clusterAgentPoolProfiles = []]

    [#list occurrence.Occurrences![] as subOccurrence]

        [#local subCore = subOccurrence.Core]
        [#local subSolution = subOccurrence.Configuration.Solution]
        [#local subResources = subOccurrence.State.Resources]

        [#if subCore.Type == ECS_SERVICE_COMPONENT_TYPE]

        [#elseif subCore.Type == ECS_TASK_COMPONENT_TYPE]

        [/#if]

    [/#list]

    [@createContainerCluster
        id=cluster.Id
        name=cluster.Name
        location=regionId
        sku={}
        poolProfiles=[getContainerAgentPoolProfile(core.ShortName, occurrence)]
    /]

[/#macro]