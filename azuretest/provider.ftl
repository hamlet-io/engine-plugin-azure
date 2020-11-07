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
[#assign AZURETEST_PROVIDER = "azuretest"]
