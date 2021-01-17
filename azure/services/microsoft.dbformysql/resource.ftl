[#ftl]

[#--
    NOTE: Resources WILL require a "Parameters" template pass.
--]

[#assign mysqlResourceProfiles = {
    AZURE_DB_MYSQL_SERVER_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "conditions" : [ "max_length", "name_to_lower", "globally_unique" ],
        "max_name_length" : 63,
        "type" : "Microsoft.DBforMySQL/servers",
        "outputMappings" : {
            URL_ATTRIBUTE_TYPE : {
                "Property" : "properties.fullyQualifiedDomainName"
            }
        }
    },
    AZURE_DB_MYSQL_SERVER_CONFIGURATION_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "type" : "Microsoft.DBforMySQL/servers/configurations",
        "outputMappings" : {}
    },
    AZURE_DB_MYSQL_SERVER_DATABASE_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "conditions" : [ "max_length", "name_to_lower", "globally_unique" ],
        "max_name_length" : 63,
        "type" : "Microsoft.DBforMySQL/servers/databases",
        "outputMappings" : {
            REFERENCE_ATTRIBUTE_TYPE : {
                "Property" : "id"
            }
        }
    },
    AZURE_DB_MYSQL_SERVER_FIREWALL_RULE_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "type" : "Microsoft.DBforMySQL/servers/firewallRules",
        "outputMappings" : {}
    },
    AZURE_DB_MYSQL_SERVER_SECURITY_ALERT_POLICY_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "type" : "Microsoft.DBforMySQL/servers/securityAlertPolicies",
        "outputMappings" : {}
    },
    AZURE_DB_MYSQL_SERVER_VNET_RULE_RESOURCE_TYPE : {
        "apiVersion" : "2017-12-01",
        "type" : "Microsoft.DBforMySQL/servers/virtualNetworkRules",
        "outputMappings" : {}
    }
}]

[#list mysqlResourceProfiles as type,profile]
    [@addResourceProfile
        service=AZURE_DB_MYSQL_SERVICE
        resource=type
        profile=profile
    /]
[/#list]

[#macro createMySqlServer
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
    sslEnforcement="Disabled"
    backupRetentionDays=""
    geoRedundandBackup=""
    storageGB=""
    storageAutogrow=""
    sourceServerId=""
    restorePointInTime=""
    dependsOn=[]]

    [#local disallowedAdminNames = [
        "azure_superuser",
        "admin",
        "administrator",
        "root",
        "guest",
        "public"
    ]]

    [#if disallowedAdminNames?seq_contains(adminName?lower_case)]
        [@precondition
            function="createMySqlServer"
            context={ "adminName": adminName, "max_length": 63, "length" : adminName?length }
            detail="Disallowed database administrator account name, or name too long."
        /]
    [/#if]

    [#if replaceAlphaNumericOnly(adminName) != adminName ]
        [@precondition
            function="createMySqlServer"
            context={ "adminName": adminName }
            detail="admin name can only contain alphanumeric characters"
        /]
    [/#if]

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
                secretName=adminSecret
                vaultId=keyvaultId
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
        profile=AZURE_DB_MYSQL_SERVER_RESOURCE_TYPE
        dependsOn=dependsOn
        properties=properties
    /]
[/#macro]

[#macro createMySqlServerConfiguration
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
        profile=AZURE_DB_MYSQL_SERVER_CONFIGURATION_RESOURCE_TYPE
        dependsOn=dependsOn
        properties={} +
            attributeIfContent("value", updatedValue) +
            attributeIfContent("source", source)
    /]
[/#macro]

[#macro createMySqlServerDatabase
    id
    name
    charset=""
    collation=""
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_DB_MYSQL_SERVER_DATABASE_RESOURCE_TYPE
        dependsOn=dependsOn
        properties={} +
            attributeIfContent("charset", charset) +
            attributeIfContent("collation", collation)
    /]
[/#macro]

[#macro createMySqlServerFirewallRule
    id
    name
    startIpAddress
    endIpAddress
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_DB_MYSQL_SERVER_FIREWALL_RULE_RESOURCE_TYPE
        dependsOn=dependsOn
        properties=
            {
                "startIpAddress" : startIpAddress,
                "endIpAddress" : endIpAddress
            }
    /]
[/#macro]

[#macro createMySqlServerSecurityAlertPolicy
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
        profile=AZURE_DB_MYSQL_SERVER_SECURITY_ALERT_POLICY_RESOURCE_TYPE
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

[#macro createMySqlServerVNetRule
    id
    name
    subnetId
    ignoreMissingEndpoint=false
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_DB_MYSQL_SERVER_VNET_RULE_RESOURCE_TYPE
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
