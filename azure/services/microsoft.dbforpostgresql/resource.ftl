[#ftl]

[#--
    NOTE: Resources WILL require a "Parameters" template pass.
--]

[#assign postgresResourceProfiles = {
    AZURE_DB_POSTGRES_SERVER_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "conditions" : [ "max_length", "name_to_lower", "globally_unique" ],
        "max_name_length" : 63,
        "type" : "Microsoft.DBforPostgreSQL/servers",
        "outputMappings" : {}
    },
    AZURE_DB_POSTGRES_SERVER_CONFIGURATION_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "type" : "Microsoft.DBforPostgreSQL/servers/configurations",
        "outputMappings" : {}
    },
    AZURE_DB_POSTGRES_SERVER_DATABASE_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "conditions" : [ "max_length", "name_to_lower", "globally_unique" ],
        "max_name_length" : 63,
        "type" : "Microsoft.DBforPostgreSQL/servers/databases",
        "outputMappings" : {
            REFERENCE_ATTRIBUTE_TYPE : {
                "Property" : "id"
            }
        }
    },
    AZURE_DB_POSTGRES_SERVER_FIREWALL_RULE_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "type" : "Microsoft.DBforPostgreSQL/servers/firewallRules",
        "outputMappings" : {}
    },
    AZURE_DB_POSTGRES_SERVER_SECURITY_ALERT_POLICY_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "type" : "Microsoft.DBforPostgreSQL/servers/securityAlertPolicies",
        "outputMappings" : {}
    },
    AZURE_DB_POSTGRES_SERVER_VNET_RULE_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "type" : "Microsoft.DBforPostgreSQL/servers/virtualNetworkRules",
        "outputMappings" : {}
    }
}]

[#list postgresResourceProfiles as type,profile]
    [@addResourceProfile
        service=AZURE_DB_POSTGRES_SERVICE
        resource=type
        profile=profile
    /]
[/#list]

[#macro createPostgresServer
    id
    name
    location
    createMode
    adminName
    adminSecret
    keyvaultId
    skuName=""
    skuTier=""
    skuCapacity=""
    skuSize=""
    skuFamily=""
    version=""
    sslEnforcement=""
    backupRetentionDays=""
    geoRedundandBackup=""
    storageGB=""
    storageAutogrow=""
    sourceServerId=""
    restorePointInTime=""
    dependsOn=[]]

    [#local disallowedAdminNames = [
        "azure_superuser",
        "azure_pg_admin",
        "admin",
        "administrator",
        "root",
        "guest",
        "public"
    ]]

    [#if disallowedAdminNames?seq_contains(adminName?lower_case) ||
        adminName?lower_case?starts_with("pg_")]
        [@precondition
            function="createPostgresServer"
            context={ "adminName": adminName, "max_length": 63, "length" : adminName?length }
            detail="Disallowed database administrator account name, or name too long."
        /]
    [/#if]

    [#local adminName = replaceAlphaNumericOnly(adminName)]

    [#local sku = {} +
        attributeIfContent("name", skuName) +
        attributeIfContent("tier", skuTier) +
        numberAttributeIfContent("capacity", skuCapacity) +
        attributeIfContent("size", skuSize) +
        attributeIfContent("family", skuFamily)
    ]

    [#local storageProfile = {} +
        numberAttributeIfContent("backupRetentionDays", backupRetentionDays) +
        attributeIfContent("geoRedundandBackup", geoRedundandBackup) +
        numberAttributeIfContent("storageMB", "${storageGB} * 1024"?eval?c) +
        attributeIfContent("storageAutogrow", storageAutogrow)
    ]

    [#local properties = { "createMode" : createMode } +
        attributeIfContent("version", version) +
        attributeIfContent("sslEnforcement", sslEnforcement) + 
        attributeIfContent("storageProfile", storageProfile)
    ]

    [#switch createMode]
        [#case "Default"]
            [#local dbadmin = getServerCreateModeDefault(
                adminName, 
                adminSecret
            )]

            [#-- Create ARM Parameter File and Template Parameter Reference to the secret --]
            [@createKeyVaultParameterLookup
                id=adminSecret
                vaultId=keyvaultId
                secretName=adminSecret
            /]

            [#-- Add parameter reference to Properties --]
            [#local properties += mergeObjects(
                dbadmin,
                { "administratorLoginPassword" : getParameterReference(adminSecret) }
            )]

            [#break]
        [#case "GeoRestore"]
        [#case "Replica"]
            [#local properties += getServerCreateModeReplica(sourceServerId)]
            [#break]
        [#case "PointInTimeRestore"]
            [#local properties += getServerCreateModePointInTimeRestore(restorePointInTime, sourceServerId)]
            [#break]
        [#default]
            [@fatal
                message="Server Create Mode must be one of: Default, GeoRestore, Replica or PointInTimeRestore."
                context=createMode
            /]
            [#break]
    [/#switch]

    [@armResource
        id=id
        name=name
        location=location
        sku=sku
        profile=AZURE_DB_POSTGRES_SERVER_RESOURCE_TYPE
        dependsOn=dependsOn
        properties=properties
    /]

[/#macro]

[#macro createPostgresServerConfiguration
    id
    name
    value=""
    source=""
    dependsOn=[]]

    [#-- Move large value configurations into Parameters file --]
    [#if value?is_hash || (value?is_string && (value!"")?length > 80)]
        [#local parameterName = formatName(name, "value")]
        [@addParametersToDefaultJsonOutput
            id=parameterName
            parameter=value
        /]

        [@armParameter
            name=parameterName
            type="string"
        /]

        [#local updatedValue = getParameterReference(parameterName)]
    [#else]
        [#local updatedValue = value]
    [/#if]

    [@armResource
        id=id
        name=name
        profile=AZURE_DB_POSTGRES_SERVER_CONFIGURATION_RESOURCE_TYPE
        dependsOn=dependsOn
        properties={} +
            attributeIfContent("value", updatedValue) +
            attributeIfContent("source", source)
    /]
[/#macro]

[#macro createPostgresServerDatabase
    id
    name
    charset=""
    collation=""
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_DB_POSTGRES_SERVER_DATABASE_RESOURCE_TYPE
        dependsOn=dependsOn
        properties={} +
            attributeIfContent("charset", charset) +
            attributeIfContent("collation", collation)
    /]

[/#macro]

[#macro createPostgresServerFirewallRule
    id
    name
    startIpAddress
    endIpAddress
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_DB_POSTGRES_SERVER_FIREWALL_RULE_RESOURCE_TYPE
        dependsOn=dependsOn
        properties=
            {
                "startIpAddress" : startIpAddress,
                "endIpAddress" : endIpAddress
            }
    /]

[/#macro]

[#macro createPostgresServerSecurityAlertPolicy
    id
    name
    state
    disabledAlerts=[]
    emailAddresses=[]
    emailAccountAdmins=false
    storageEndpoint=""
    storageAccountAccessKey=""
    retentionDays=""
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_DB_POSTGRES_SERVER_SECURITY_ALERT_POLICY_RESOURCE_TYPE
        dependsOn=dependsOn
        properties=
            {
                "state" : state
            } +
            attributeIfContent("disabledAlerts", disabledAlerts) +
            attributeIfContent("emailAddresses", emailAddresses) +
            attributeIfTrue("emailAccountAdmins", emailAccountAdmins, emailAccountAdmins) +
            attributeIfContent("storageEndpoint", storageEndpoint) +
            attributeIfContent("storageAccountAccessKey", storageAccountAccessKey) +
            numberAttributeIfContent("retentionDays", retentionDays)
    /]

[/#macro]

[#macro createPostgresServerVNetRule
    id
    name
    subnetId
    ignoreMissingEndpoint=false
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_DB_POSTGRES_SERVER_VNET_RULE_RESOURCE_TYPE
        dependsOn=dependsOn
        properties=
            {
                "virtualNetworkSubnetId" : subnetId
            } +
            attributeIfTrue(
                "ignoreMissingVnetServiceEndpoint",
                ignoreMissingEndpoint,
                ignoreMissingEndpoint
            )
    /]

[/#macro]

[#-- Internal Use Only --]
[#-- Components should not directly call these functions. --]
[#function getServerCreateModeDefault login secret]
    [#return
        {
            "administratorLogin" : login,
            "administratorLoginPassword" : secret
        }
    ]
[/#function]

[#function getServerCreateModeReplica sourceServerId]
    [#return { "sourceServerId" : sourceServerId }]
[/#function]

[#function getServerCreateModePointInTimeRestore time sourceServerId]
    [#return
        {
            "restorePointInTime" : time?string.iso,
            "sourceServerId" : sourceServerId
        }
    ]
[/#function]