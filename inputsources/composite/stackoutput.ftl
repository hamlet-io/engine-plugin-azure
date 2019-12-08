[#ftl]

[#-- Get stack output --]
[#function azure_input_composite_stackoutput_filter outputFilter]
  [#return 
    {
      "Subscription" : (outputFilter.Account)!accountObject.AWSId,
      "Region" : outputFilter.Region,
      "DeploymentUnit" : outputFilter.DeploymentUnit
    }
  ]
[/#function]

[#macro azure_input_composite_stackoutput_seed]

  [#local deploymentOutputs = []]

  [#-- ARM Stack Output Processing --]
  [#list commandLineOptions.Composites.StackOutputs as deploymentTemplate]

    [#local level = ((deploymentTemplate["FileName"])?split('-'))[0]]
    [#list (deploymentTemplate["Content"]![]) as rawDeploymentOutput]
      [#if (rawDeploymentOutput["properties"]["outputs"]!{})?has_content]

        [#local deploymentOutput = {
          "Level" : level
        }]

        [#list rawDeploymentOutput["properties"]["outputs"] as outputId, outputValue]   
          [#local deploymentOutput += {
            outputId : outputValue.value
          }]
        [/#list]

        [#local deploymentOutputs += [ deploymentOutput ]]

      [/#if]
    [/#list]
  [/#list]

  [@addStackOutputs stackOutputs /]

[/#macro]