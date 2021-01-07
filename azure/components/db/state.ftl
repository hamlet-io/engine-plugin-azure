[#ftl]

[#macro azure_db_arm_state occurrence parent={}]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local engine = solution.Engine]

    [#switch engine]
        [#case "postgres"]
            [#local server_resource_type = AZURE_DB_POSTGRES_SERVER_RESOURCE_TYPE]
            [#local server_database_resource_type = AZURE_DB_POSTGRES_SERVER_DATABASE_RESOURCE_TYPE]
            [#local server_vnet_rule_resource_type = AZURE_DB_POSTGRES_SERVER_VNET_RULE_RESOURCE_TYPE]
            [#local server_config_resource_type = AZURE_DB_POSTGRES_SERVER_CONFIGURATION_RESOURCE_TYPE]
            [#break]

        [#case "mysql"]
            [#local server_resource_type = AZURE_DB_MYSQL_SERVER_RESOURCE_TYPE]
            [#local server_database_resource_type = AZURE_DB_MYSQL_SERVER_DATABASE_RESOURCE_TYPE]
            [#local server_vnet_rule_resource_type = AZURE_DB_MYSQL_SERVER_VNET_RULE_RESOURCE_TYPE]
            [#local server_config_resource_type = AZURE_DB_MYSQL_SERVER_CONFIGURATION_RESOURCE_TYPE]
            [#break]

    [/#switch]


    [#local dbServerId = formatResourceId(server_resource_type, core.ShortName)]
    [#local dbServerName = formatAzureResourceName(
        formatName(server_resource_type, core.ShortName)
        server_resource_type
    )]
    [#local databaseId = formatResourceId(server_database_resource_type, core.ShortName)]
    [#local databaseRawName = solution.DatabaseName!productName]
    [#local databaseName = formatAzureResourceName(
        databaseRawName,
        server_database_resource_type,
        dbServerName
    )]

    [#-- One Resource Per Key:Value pair in the DBParameters attribute. --]
    [#local configs = {}]
    [#list solution.DBParameters?keys as key]
        [#local configId = formatResourceId(server_config_resource_type, key)]
        [#local configName = formatAzureResourceName(
            key,
            server_config_resource_type,
            dbServerName
        )]
        [#local configs += { 
            key : {
                "Id" : configId,
                "Name" : configName,
                "Type" : server_config_resource_type,
                "Reference": getReference(configId, configName)
            }}]
    [/#list]

    [#local vnetRuleId = formatResourceId(server_vnet_rule_resource_type, core.ShortName)]
    [#local vnetRuleName = formatAzureResourceName(
        formatName(server_vnet_rule_resource_type, core.ShortName),
        server_vnet_rule_resource_type,
        dbServerName
    )]

    [#-- Credential Management --]
    [#if solution.GenerateCredentials.Enabled]
        [#local masterUsername = solution.GenerateCredentials.MasterUserName]
        [#local masterSecret = formatSecretName(core.ShortFullName)]
    [#else]
        [#-- don't flag an error if credentials missing but component is not enabled --]
        [#local masterUsername = getOccurrenceSettingValue(occurrence, "MASTER_USERNAME", !solution.Enabled) ]
        [#local masterSecret = getOccurrenceSettingValue(occurrence, "MASTER_SECRET", !solution.Enabled) ]
    [/#if]

    [#local fqdn = getReference(dbServerId, dbServerName, URL_ATTRIBUTE_TYPE)]

    [#assign componentState =
        {
            "Resources" : {
                "dbserver" : {
                    "Id" : dbServerId,
                    "Name" : dbServerName,
                    "Type" : server_resource_type,
                    "Reference": getReference(dbServerId, dbServerName)
                },
                "database" : {
                    "Id" : databaseId,
                    "Name" : databaseName,
                    "Type" : server_database_resource_type,
                    "Reference": getReference(databaseId, databaseName)
                },
                "dbconfigs" : configs,
                "dbvnetrule" : {
                    "Id" : vnetRuleId,
                    "Name" : vnetRuleName,
                    "Type" : server_vnet_rule_resource_type,
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
