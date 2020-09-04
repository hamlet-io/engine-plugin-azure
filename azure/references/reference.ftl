[#ftl]

[#assign SKU_PROFILE_REFERENCE_TYPE = "SkuProfile"]
[#assign VIRTUAL_MACHINE_IMAGE_REFERENCE_TYPE = "VMImageProfile"]

[#function getAutoScaleRule
  metricName
  resourceId
  timeGrain
  statistic
  timeWindow
  timeAggregation
  operator
  threshold
  direction
  actionType
  cooldown
  actionValue=""]

  [#return
    {
      "metricTrigger" : {
        "metricName" : metricName,
        "metricResourceUri" : resourceId,
        "timeGrain" : timeGrain,
        "statistic" : statistic,
        "timeWindow" : timeWindow,
        "timeAggregation" : timeAggregation,
        "operator" : operator,
        "threshold" : threshold
      },
      "scaleAction" : {
        "direction" : direction,
        "type" : actionType,
        "cooldown" : cooldown
      } +
      attributeIfContent("value", actionValue)
    }
  ]

[/#function]

[#function getAutoScaleProfile
  name
  minCapacity
  maxCapacity
  defaultCapacity
  rules
  fixedDate={}
  recurrence={}]

  [#return 
    {
      "name" : name,
      "capacity" : {
        "minimum" : minCapacity,
        "maximum" : maxCapacity,
        "default" : defaultCapacity
      },
      "rules" : rules
    } +
    attributeIfContent("fixedDate", fixedDate) +
    attributeIfContent("recurrence", recurrence)
  ]

[/#function]

[#function getOccurrenceReferenceProfiles occurrence]

    [#local type = occurrence.Core.Type]
    [#local resources = occurrence.State.Resources]
    [#local solution = occurrence.Configuration.Solution]
    [#local engine = solution.Engine!""]

    [#-- Profiles --]
    [#local skuProfile = getSkuProfile(occurrence, type, engine)]

    [#-- Processor --]
    [#local processorProfile = getProcessor(occurrence, type)]

    [#-- Storage --]
    [#local storageProfile = getStorage(occurrence, type)]

    [#-- Image --]
    [#local imageProfile = getVMImageProfile(occurrence, type)]

    [#-- AutoScale --]
    [#local autoScaleProfiles = []]
    [#local scaleRules = []]
    [#local scaleSetHost = resources["host"]!resources["plan"]!{}]
    [#if (solution["azure:ScalingProfiles"]!{})?has_content]

        [#list solution["azure:ScalingProfiles"] as profileId,profile]
            [#list profile.ScalingRules!{} as ruleId,rule]
                [#local scaleRules += [
                    getAutoScaleRule(
                        rule.MetricName,
                        scaleSetHost.Reference,
                        rule.TimeGrain,
                        rule.Statistic,
                        rule.TimeWindow,
                        rule.TimeAggregation,
                        rule.Operator,
                        rule.Threshold,
                        rule.Direction,
                        rule.ActionType,
                        rule.Cooldown,
                        rule.ActionValue!""
                    )
                ]]
            [/#list]

            [#local autoScaleProfiles += [ 
                getAutoScaleProfile(
                    profileId,
                    processorProfile.MinCount,
                    processorProfile.MaxCount,
                    processorProfile.DesiredCount,
                    scaleRules
                )]]
        [/#list]
    [/#if]


    [#return {} +
        attributeIfContent("Image", imageProfile) +
        attributeIfContent("Processor", processorProfile) +
        attributeIfContent("SKU", skuProfile) +
        attributeIfContent("Scale", autoScaleProfiles) +
        attributeIfContent("Storage", storageProfile)]
[/#function]