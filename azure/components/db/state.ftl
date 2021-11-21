[#ftl]

[#macro azure_db_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local engine = solution.Engine]

    [#switch engine]
        [#case "postgres"]
            [#local serverResourceType = AZURE_DB_POSTGRES_SERVER_RESOURCE_TYPE]
            [#local serverDatabaseResourceType = AZURE_DB_POSTGRES_SERVER_DATABASE_RESOURCE_TYPE]
            [#local serverVnetRuleResourceType = AZURE_DB_POSTGRES_SERVER_VNET_RULE_RESOURCE_TYPE]
            [#local serverConfigResourceType = AZURE_DB_POSTGRES_SERVER_CONFIGURATION_RESOURCE_TYPE]
            [#break]

        [#case "mysql"]
            [#local serverResourceType = AZURE_DB_MYSQL_SERVER_RESOURCE_TYPE]
            [#local serverDatabaseResourceType = AZURE_DB_MYSQL_SERVER_DATABASE_RESOURCE_TYPE]
            [#local serverVnetRuleResourceType = AZURE_DB_MYSQL_SERVER_VNET_RULE_RESOURCE_TYPE]
            [#local serverConfigResourceType = AZURE_DB_MYSQL_SERVER_CONFIGURATION_RESOURCE_TYPE]
            [#break]

    [/#switch]


    [#local dbServerId = formatResourceId(serverResourceType, core.ShortName)]
    [#local dbServerName = formatAzureResourceName(
        formatName(serverResourceType, core.ShortName)
        serverResourceType
    )]
    [#local databaseId = formatResourceId(serverDatabaseResourceType, core.ShortName)]
    [#local databaseRawName = solution.DatabaseName!productName]
    [#local databaseName = formatAzureResourceName(
        databaseRawName,
        serverDatabaseResourceType,
        dbServerName
    )]

    [#-- One Resource Per Key:Value pair in the DBParameters attribute. --]
    [#local configs = {}]
    [#list solution.DBParameters?keys as key]
        [#local configId = formatResourceId(serverConfigResourceType, key)]
        [#local configName = formatAzureResourceName(
            key,
            serverConfigResourceType,
            dbServerName
        )]
        [#local configs += {
            key : {
                "Id" : configId,
                "Name" : configName,
                "Type" : serverConfigResourceType,
                "Reference": getReference(configId, configName)
            }}]
    [/#list]

    [#local vnetRuleId = formatResourceId(serverVnetRuleResourceType, core.ShortName)]
    [#local vnetRuleName = formatAzureResourceName(
        formatName(serverVnetRuleResourceType, core.ShortName),
        serverVnetRuleResourceType,
        dbServerName
    )]

    [#local credentialSource = solution["rootCredential:Source"]]
    [#if isPresent(solution["rootCredential:Generated"]) && credentialSource != "Generated"]
        [#local credentialSource = "Generated"]
    [/#if]

    [#-- Credential Management --]
    [#switch credentialSource]
        [#case "Generated"]
            [#local masterUsername = solution["rootCredential:Generated"].Username]
            [#local masterSecret = formatSecretName(core.ShortFullName)]

            [#break]

        [#case "Settings"]
            [#-- don't flag an error if credentials missing but component is not enabled --]
            [#local masterUsername = getOccurrenceSettingValue(occurrence, solution["rootCredential:Settings"].UsernameAttribute, !solution.Enabled) ]
            [#local masterSecret = getOccurrenceSettingValue(occurrence, solution["rootCredential:Settings"].PasswordAttribute, !solution.Enabled) ]
            [#break]

    [/#switch]

    [#local fqdn = getReference(dbServerId, dbServerName, URL_ATTRIBUTE_TYPE)]

    [#assign componentState =
        {
            "Resources" : {
                "dbserver" : {
                    "Id" : dbServerId,
                    "Name" : dbServerName,
                    "Type" : serverResourceType,
                    "Reference": getReference(dbServerId, dbServerName)
                },
                "database" : {
                    "Id" : databaseId,
                    "Name" : databaseName,
                    "Type" : serverDatabaseResourceType,
                    "Reference": getReference(databaseId, databaseName)
                },
                "dbconfigs" : configs,
                "dbvnetrule" : {
                    "Id" : vnetRuleId,
                    "Name" : vnetRuleName,
                    "Type" : serverVnetRuleResourceType,
                    "Reference": getReference(vnetRuleId, vnetRuleName)
                }
            },
            "Attributes" : {
                "DB_NAME" : databaseName?keep_after_last("/"),
                "USERNAME" : masterUsername + '@' + fqdn,
                "FQDN" : fqdn,
                "SECRET" : masterSecret
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]
[/#macro]
