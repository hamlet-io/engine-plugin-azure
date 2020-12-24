[#ftl]

[#macro azure_input_mock_stackoutput id="" deploymentUnit="" level="" region="" account=""]

  [#switch id?split("X")?last ]
    [#case NAME_ATTRIBUTE_TYPE]
      [#local value = AZURE_RESOURCE_NAME_MOCK_VALUE]
      [#break]
    [#case URL_ATTRIBUTE_TYPE ]
      [#local value = AZURE_RESOURCE_URL_MOCK_VALUE + id ]
      [#break]
    [#case IP_ADDRESS_ATTRIBUTE_TYPE ]
      [#local value = AZURE_RESOURCE_IP_ADDRESS_MOCK_VALUE ]
      [#break]
    [#case REGION_ATTRIBUTE_TYPE ]
      [#local value = AZURE_REGION_MOCK_VALUE ]
      [#break]
    [#default]
      [#--The default value will be an azure resource Id --]
      [#local value = AZURE_RESOURCE_ID_MOCK_VALUE]
      [#break]
    [/#switch]

    [@addStackOutputs 
      [
        {
          "Subscription" : account!AZURE_SUBSCRIPTION_MOCK_VALUE,
          "Region" : region!AZURE_REGION_MOCK_VALUE,
          "DeploymentUnit" : deploymentUnit!getDeploymentUnit(),
          id : value
        }
      ]
    /]

[/#macro]