[#ftl]

[#macro azure_sqs_arm_genplan_solution occurrence]
    [#-- Queue creation is not yet available within ARM                --]
    [#-- No template is therefore required - all work done through CLI --]
    [#-- TODO(rossmurr4y): Keep an eye on ARM support:                 --]
    [#-- https://tinyurl.com/r2zpv8v                                   --]
    [@addDefaultGenerationPlan subsets=["prologue"] /]
[/#macro]

[#macro azure_sqs_arm_setup_solution occurrence]
    
    [@debug message="Entering SQS Setup" context=occurrence enabled=false /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#if deploymentSubsetRequired("prologue", true)]

        [#local queue = resources["queue"]]

        [@addToDefaultBashScriptOutput
            content=
            [
                "case $\{DEPLOYMENT_OPERATION} in",
                "  create|update)"
                "    # Create Storage Account Queue",
                "    info \"Creating Queue Storage ... \"",
                "    az_interact_storage_queue" +
                    " \"" + queue.StorageAccount + "\"" +
                    " \"" + queue.Name + "\"" +
                    " \"" + "create" + "\" || return $?"
                    ";;",
                "  delete)"
                "    # Deleting Storage Account Queue",
                "    info \"Deleting Queue Storage ... \"",
                "    az_interact_storage_queue" +
                    " \"" + queue.StorageAccount + "\"" +
                    " \"" + queue.Name + "\"" +
                    " \"" + "delete" + "\" || return $?"
                    ";;",
                "esac"
            ]
        /]

    [/#if]

[/#macro]