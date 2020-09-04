[#ftl]

[#macro azure_ecs_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local hostId = formatResourceId(
        AZURE_APP_SERVICE_PLAN_RESOURCE_TYPE,
        core.FullName)]
    [#local hostName = formatAzureResourceName(
        core.FullName,
        AZURE_APP_SERVICE_PLAN_RESOURCE_TYPE)]

    [#assign componentState =
        {
            "Resources" : {
                "host" : {
                    "Id" : hostId,
                    "Name" : hostName,
                    "Type" : AZURE_APP_SERVICE_PLAN_RESOURCE_TYPE,
                    "Reference" : getReference(planId, planName)
                }
            },
            "Attributes" : {

            },
            "Roles" : {}
        }
    ]
[/#macro]

[#macro azure_service_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#-- Determine Host by Parent or Link --]
    [#local hostOccurrence = {}]
    [#if parent?has_content]
        [#local hostOccurrence = parent]
    [#else]
        [#list solution.Links?values as link]
            [#if link?is_hash]
                [#local linkTarget = getLinkTarget(occurrence, link) ]

                [#if !linkTarget?has_content || 
                    !(linkTarget.Configuration.Solution.Enabled!true) ]
                    [#continue]
                [/#if]

                [#switch linkTarget.Core.Type]
                    [#case ECS_COMPONENT_TYPE]
                        [#local hostOccurrence = linkTarget]
                        [#break]
                [/#switch]
            [/#if]
        [/#list]
    [/#if]

    [#local hostResources = hostOccurrence.State.Resources]
    [#local hostAttributes = hostOccurrence.State.Attributes]

    [#assign componentState =
        {
            "Resources" : {},
            "Attributes" : {},
            "Roles" : {}
        }
    ]
[/#macro]

[#macro azure_task_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local parentResources = parent.State.Resources]
    [#local parentAttributes = parent.State.Attributes]

    [#assign componentState =
        {
            "Resources" : {},
            "Attributes" : {},
            "Roles" : {}
        }
    ]
[/#macro]