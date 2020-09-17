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

[#function getAutoScaleProfiles occurrence profiles hostId]
     [#local solution = occurrence.Configuration.Solution]
    [#local result = []]
    [#local scaleRules = []]
    [#if (solution["azure:Profiles"].Scaling!{})?has_content]
        [#list solution["azure:Profiles"].Scaling as profileId,profile]
            [#list profile.ScalingRules!{} as ruleId,rule]
                [#local scaleRules += [
                    getAutoScaleRule(
                        rule.MetricName,
                        hostId,
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

            [#local result += [ 
                getAutoScaleProfile(
                    profileId,
                    profiles.Processor.MinCount,
                    profiles.Processor.MaxCount,
                    profiles.Processor.DesiredCount,
                    scaleRules
                )]]
        [/#list]
    [/#if]
    [#return result]
[/#function]

[#function getOccurrenceProfiles occurrence]

    [#local type = occurrence.Core.Type]
    [#local resources = occurrence.State.Resources]
    [#local solution = occurrence.Configuration.Solution]
    [#local engine = solution.Engine!""]

    [#local providerProfiles = mergeObjects(solution.Profiles, solution["azure:Profiles"]!{})]

    [#local result = {}]
    [#list providerProfiles as name,value]
      [#switch name]
        [#case "Security"]
          [#local result += attributeIfContent(name, getSecurityProfile(value, type, engine)!{})]
          [#break]

        [#case "Storage"]
          [#local result += attributeIfContent(name, getStorage(occurrence, type)!{})]

        [#case "Alert"]
          [#local result += attributeIfContent(name, getReferenceData(ALERTPROFILE_REFERENCE_TYPE)[value]!{})]
          [#break]

        [#case "Logging"]
          [#local result += attributeIfContent(name, getLoggingProfile(value)!{})]
          [#break]

        [#case "Processor"]
          [#local result += attributeIfContent(name, getProcessor(occurrence, type)!{})]
          [#break]

        [#case "Network"]
          [#local result += attributeIfContent(name, getNetworkProfile(value)!{})]
          [#break]

        [#case "Bootstrap"]
          [#local result += attributeIfContent(name, getBootstrapProfile(occurrence, type)!{})]
          [#break]

        [#case "CORS"]
          [#local result += attributeIfContent(name, CORSProfiles[value]!{})]
          [#break]

        [#case "LogFile"]
          [#local result += attributeIfContent(name, getLogFileProfile(occurrence, value)!{})]
          [#break]

        [#case "Testing"]
          [#local result += attributeIfContent(name, value?map(p -> testProfiles[p])![])]
          [#break]

        [#case "WAF"]
          [#local result += attributeIfContent(name, wafProfiles[value]!{})]
          [#break]

        [#case "Baseline"]
          [#local result += attributeIfContent(name, baselineProfiles[value]!{})]
          [#break]

        [#-- Azure Specific --]
        [#case "Sku"]
          [#local result += attributeIfContent(name, getSkuProfile(occurrence, type, engine)!{})]
          [#break]

        [#case "VMImage"]
          [#local result += attributeIfContent(name, getVMImageProfile(occurrence, type)!{})]
          [#break]

        [#case "Scaling"]
          [#-- to be removed - #194 --]
          [#break]

        [#default]
          [@debug message="Unknown Profile Found" context={name : value} enabled=false /]
          [#break]

      [/#switch]
    [/#list]

    [@debug message="Occurrence Profile Configuration" context=result enabled=false /]
    [#return result]
[/#function]