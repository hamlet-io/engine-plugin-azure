[#ftl]

[#-- Resources --]
[#-- As there are no assicated Service's for this --]
[#-- component, the resources are defined here.   --]
[#assign COT_ADAPTOR_RESOURCE_TYPE = "adaptor"]

[#macro azure_adaptor_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local id = formatResourceId(COT_ADAPTOR_RESOURCE_TYPE, core.Id)]

    [#assign componentState = 
        {
            "Resources" : {
                "adaptor" : {
                    "Id" : id,
                    "Type" : COT_ADAPTOR_RESOURCE_TYPE
                }
            },
            "Attributes" : {}
        }
    ]

[/#macro]