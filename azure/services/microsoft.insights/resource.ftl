[#ftl]

[@addResourceProfile
  service=AZURE_INSIGHTS_SERVICE
  resource=AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2015-04-01",
      "type" : "Microsoft.Insights/autoscaleSettings",
      "outputMappings" : {
        REFERENCE_ATTRIBUTE_TYPE : {
          "Property" : "id"
        }
      }
    }
/]

[#function getAutoScaleProfileSchedule
  frequency
  timeZone
  daysOfWeek
  hours
  minutes]

  [#return
    {
      "frequency" : frequency,
      "schedule" : {
        "timeZone" : timeZone,
        "days" : asFlattenedArray(daysOfWeek),
        "hours" : asFlattenedArray(hours),
        "minutes" : asFlattenedArray(minutes)
      }
    }
  ]
[/#function]

[#function getAutoScaleMetricRule
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

[#function getAutoScaleProfile name objectId profile]

  [#local rules = []]
  [#local schedule = {}]

  [#list profile.Rules as name, rule]
    [#local rules += [
      getAutoScaleMetricRule(
        rule.MetricName,
        objectId,
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
      )]]
  [/#list]
  
  [#if profile.Schedule.Enabled || profile.Schedule.Configured]
    [#local schedule = 
      getAutoScaleProfileSchedule(
        profile.Schedule.Frequency,
        profile.Schedule.TimeZone,
        profile.Schedule.Days,
        profile.Schedule.Hours,
        profile.Schedule.Minutes)]
  [/#if]

  [#return 
    {
      "name" : name,
      "capacity" : {
        "minimum" : profile.MinCapacity,
        "maximum" : profile.MaxCapacity,
        "default" : profile.DefaultCapacity
      },
      "rules" : rules
    } +
    attributeIfContent("recurrence", schedule)]
[/#function]

[#macro createAutoscaleSettings
  id
  name
  location
  targetId
  profiles
  enabled=true
  notifications=[]
  dependsOn=[]]

  [@armResource
    id=id
    name=name
    profile=AZURE_AUTOSCALE_SETTINGS_RESOURCE_TYPE
    location=location
    dependsOn=dependsOn
    properties=
      {
        "name" : name,
        "enabled" : enabled,
        "profiles" : profiles,
        "targetResourceUri" : targetId
      } +
      attributeIfContent("notifications", notifications)
  /]

[/#macro]