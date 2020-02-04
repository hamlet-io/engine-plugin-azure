[#ftl]

[#macro azure_lambda_arm_genplan_application occurrence]
    [@addDefaultGenerationPlan subsets=["template"] /]
[/#macro]

[#macro azure_lambda_arm_setup_application occurrence]
    [@debug message="Entering Lambda ARM Setup" context=occurrence enabled=true /]

    [#list occurrence.Occurrences![] as subOccurrence]
        [@debug message="Entering Function ARM Setup" context=occurrence enabled=true /]
    [/#list]

[/#macro]
