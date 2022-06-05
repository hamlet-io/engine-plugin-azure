[#ftl]

[@addExtension
    id="azure_adaptorbase"
    aliases=[
        "_azure_adaptorbase"
    ]
    description=[
        "Test extension for adaptor base"
    ]
    supportedTypes=[
        ADAPTOR_COMPONENT_TYPE
    ]
/]

[#macro shared_extension_azure_adaptorbase_deployment_setup occurrence ]

    [@Settings
        {
            "Name": occurrence.Core.FullName
        }
    /]

[/#macro]
