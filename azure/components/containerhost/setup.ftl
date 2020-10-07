[#ftl]

[#macro azure_containerhost_arm_deployment_generationcontract occurrence]
    [@addDefaultGenerationContract subsets=["template"] /]
[/#macro]

[#macro azure_containerhost_arm_deployment occurrence]

    [@debug message="Entering Function ARM Setup" context=occurrence enabled=false /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local isAutoScaling = solution.AutoScaling.Enabled]
    [#local resources = occurrence.State.Resources]
    [#local profiles = getOccurrenceProfiles(occurrence)]

    [#switch solution.Engine]
        [#default]
            [#local host = resources["plan"]!{}]
            [@createAppServicePlan
                id=host.Id
                name=host.Name
                location=regionId
                sku=getAppServicePlanSku(profiles)
                properties=getAppServicePlanProperties(profiles)
                kind=getAppServicePlanKind(profiles)
            /]

            [#if isAutoScaling]
                [#local autoscaleSettings = resources["autoscale"]]
                [@createAutoscaleSettings
                    id=autoscaleSettings.Id
                    name=autoscaleSettings.Name
                    location=regionId
                    profiles=getAutoScaleProfiles(occurrence, profiles host.Reference)
                    targetId=host.Reference
                    dependsOn=[host.Reference]
                /]
            [/#if]

            [#break]
    [/#switch]

[/#macro]
