[#ftl]

[#assign AZURETEST_PROVIDER = "azuretest"]
[#assign AZURETEST_FRAMEWORK = "arm"]

[#assign testScenarios = [
    [#-- "adaptor", TODO : requires ability to mock a fragment --]
    "apigateway",
    "baseline",
    "bastion",
    "cdn",
    "computecluster",
    "db",
    [#-- "gateway", github.com/hamlet-io/engine-plugin-azure/pull/53 --]
    [#-- "lambda", fragments --]
    "lb",
    "network",
    "s3"
    [#-- "spa", fragments --]
    [#-- "sqs", TODO : requires bash structural testing --]
    [#-- "userpool" bash --]
]]

[@updateScenarioList
    scenarioIds=testScenarios
/]
