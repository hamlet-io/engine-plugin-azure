[#ftl]

[#macro azure_ecs_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local clusterId = formatResourceId(
        AZURE_CONTAINERS_CLUSTER_RESOURCE_TYPE,
        core.FullName)]
    [#local clusterName = formatAzureResourceName(
        core.FullName,
        AZURE_CONTAINERS_CLUSTER_RESOURCE_TYPE)]

    [#assign componentState =
        {
            "Resources" : {
                "cluster" : {
                    "Id" : clusterId,
                    "Name" : clusterName,
                    "Type" : AZURE_CONTAINERS_CLUSTER_RESOURCE_TYPE,
                    "Reference" : getReference(clusterId, clusterName)
                }
            },
            "Attributes" : {},
            "Roles" : {}
        }
    ]
[/#macro]

[#macro azure_service_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

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

    [#assign componentState =
        {
            "Resources" : {},
            "Attributes" : {},
            "Roles" : {}
        }
    ]
[/#macro]