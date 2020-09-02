[#ftl]

[#macro azure_ecs_arm_generationcontract_application occurrence]
    [@addDefaultGenerationContract subsets=["template", "parameters"] /]
[/#macro]

[#macro azure_ecs_arm_setup_application occurrence]

    [@debug message="Entering Function ARM Setup" context=occurrence enabled=true /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#-- resources --]
    [#local cluster = resources["cluster"]]

    [#-- Baseline Component Lookup --]
    [#local baselineLinks = getBaselineLinks(occurrence, ["SSHKey"], false, false)]
    [#local baselineAttributes = baselineLinks["SSHKey"].State.Attributes]
    [#local baselineResources = baselineLinks["SSHKey"].State.Resources]
    [#local sshKey = baselineResources["vmKeyPair"]]
    [#local sshPublicKeyParameterName = sshKey.Name + "PublicKey"]

    [#local clusterAgentPoolProfiles = []]

    [#list occurrence.Occurrences![] as subOccurrence]

        [#local subCore = subOccurrence.Core]
        [#local subSolution = subOccurrence.Configuration.Solution]
        [#local subResources = subOccurrence.State.Resources]

        [#if subCore.Type == ECS_SERVICE_COMPONENT_TYPE]

        [#elseif subCore.Type == ECS_TASK_COMPONENT_TYPE]

        [/#if]

    [/#list]

    [#local clusterHostSku = getObjectAttributes(
        getSkuProfile(occurrence, core.Type),
        ["Name", "Tier"]
    )]

    [#local clusterHostOS = getVMImageProfile(occurrence, "ecs").Image!""]
    [#local masterUsername = getOccurrenceSettingValue(occurrence, "MASTER_USERNAME", true)]
    [#local username = masterUsername?has_content?then(masterUsername, "azureuser")]

    [#if deploymentSubsetRequired("parameters", true)]

      [@createKeyVaultParameterLookup
        secretName=sshPublicKeyParameterName
        vaultId=baselineAttributes["KEYVAULT_ID"]
      /]

      [#local sshKeyData = getParameterReference(sshPublicKeyParameterName)]

  [/#if]

    [@createContainerCluster
        id=cluster.Id
        name=cluster.Name
        location=regionId
        sku=clusterHostSku
        poolProfiles=[getContainerAgentPoolProfile(core.ShortName, occurrence)]
        osProfile=getContainerClusterOSProfile(username, clusterHostOS, sshKeyData!"")
    /]

[/#macro]