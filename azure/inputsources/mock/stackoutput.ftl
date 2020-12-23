[#ftl]

[#macro azure_input_mock_stackoutput id="" deploymentUnit="" level="" region="" account=""]

  [#local mockSubscription = accountObject.ProviderId]
  [#local mockResourceGroup = "mockRG"]
  [#local mockProvider = "Microsoft.Mock"]
  [#local mockRegion = "mockedRegion"]
  [#local mockResourceType = "mockResourceType"]
  [#local mockResourceName = "mockResourceName"]

  [#switch id?split("X")?last ]
    [#case NAME_ATTRIBUTE_TYPE]
      [#local value = "mockResourceName"]
      [#break]
    [#case URL_ATTRIBUTE_TYPE ]
      [#local value = "https://mock.local/" + id ]
      [#break]
    [#case IP_ADDRESS_ATTRIBUTE_TYPE ]
      [#local value = "123.123.123.123" ]
      [#break]
    [#case REGION_ATTRIBUTE_TYPE ]
      [#local value = "westus" ]
      [#break]
    [#default]
      [#--The default value will be an azure resource Id --]
      [#local value = formatPath(
                        true, 
                        [
                          "subscriptions", 
                          mockSubscription, 
                          "resourceGroups", 
                          mockResourceGroup, 
                          "providers", 
                          mockProvider, 
                          mockResourceType, 
                          mockResourceName
                        ] 
      )]
      [#break]
    [/#switch]

    [@addStackOutputs 
      [
        {
          "Subscription" : account,
          "Region" : region,
          "DeploymentUnit" : deploymentUnit,
          id : value
        }
      ]
    /]

[/#macro]