[#ftl]

[#assign AZURETEST_PROVIDER = "azuretest"]
[#assign AZURETEST_FRAMEWORK = "arm"]

[#assign testScenarios = [
    [#-- "adaptor", requires ability to mock a fragment --]
    "apigateway",
    "baseline",
    "bastion",
    "cdn",
    "computecluster",
    "db",
    [#-- "gateway", github.com/hamlet-io/engine-plugin-azure/pull/53 --]
    "lambda",
    "network",
    "s3"
]]

[@updateScenarioList
    scenarioIds=testScenarios
/]