[#ftl]

[#--
    The test provider loads in modules with test configuration
    which is used to perform unit tests of the templates we generate

    To add a new test module
    - Add a new module under the module folder in this provider
    - Update the inputsources data to load the module

    All modules will be loaded over the top of each other
    Make sure to add the data appropriately

--]
[#assign AZURETEST_PROVIDER = "azuretest" ]

[#-- Globals to ensure consistency across testing provider --]
[#assign AZURE_REGION_MOCK_VALUE = "westus" ]
[#assign AZURE_SUBSCRIPTION_MOCK_VALUE = "0123456789" ]
[#assign AZURE_RESOURCEGROUP_MOCK_VALUE = "mockRG" ]
[#assign AZURE_SERVICE_NAME_MOCK_VALUE = "Microsoft.Mock" ]
[#assign AZURE_RESOURCE_TYPE_MOCK_VALUE = "mockResourceType" ]
[#assign AZURE_RESOURCE_NAME_MOCK_VALUE = "mockName" ]
[#assign AZURE_RESOURCE_ID_MOCK_VALUE = 
    formatPath(
        true, 
        [
            "subscriptions", 
            AZURE_SUBSCRIPTION_MOCK_VALUE, 
            "resourceGroups", 
            AZURE_RESOURCEGROUP_MOCK_VALUE, 
            "providers", 
            AZURE_SERVICE_NAME_MOCK_VALUE, 
            AZURE_RESOURCE_TYPE_MOCK_VALUE, 
            AZURE_RESOURCE_NAME_MOCK_VALUE
        ] 
    )]
[#assign AZURE_RESOURCE_URL_MOCK_VALUE = "https://mock.local/" ]
[#assign AZURE_RESOURCE_IP_ADDRESS_MOCK_VALUE = "123.123.123.123" ]
[#assign AZURE_BUILD_COMMIT_MOCK_VALUE = "123456789#MockCommit#" ]