[#ftl]

[#assign AZURETEST_PROVIDER = "azuretest"]
[#assign AZURETEST_FRAMEWORK = "arm"]

[#assign testScenarios = [
    "baseline",
    "s3"
]]

[@updateScenarioList
    scenarioIds=testScenarios
/]