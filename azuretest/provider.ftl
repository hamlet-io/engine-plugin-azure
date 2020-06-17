[#ftl]

[#assign AZURETEST_PROVIDER = "azuretest"]
[#assign AZURETEST_FRAMEWORK = "arm"]

[#assign testScenarios = [
    "s3"
]]

[@updateScenarioList
    scenarioIds=testScenarios
/]