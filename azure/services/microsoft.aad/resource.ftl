[#ftl]

[@addResourceProfile
  service=AZURE_AAD_SERVICE
  resource=AZURE_AAD_DIRECTORY_SERVICES_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2021-05-01",
      "type" : "Microsoft.AAD/DomainServices",
      "outputMappings" : {
        REFERENCE_ATTRIBUTE_TYPE : {
          "Property" : "id"
        }
      }
    }
/]

[#macro createAzAzureAdDirectoryService
  id
  name
  location
  sku
  domainConfigurationType
  domainName
  filteredSync
  subnetReferences=[]
  dependsOn={}]

  [#local replicaSets = subnetReferences?map(x -> { "subnetId" : x, "location" : location }) ]

  [@armResource
    id=id
    name=name
    profile=AZURE_AAD_DIRECTORY_SERVICES_RESOURCE_TYPE
    location=location
    dependsOn=dependsOn
    properties=
      {
        "domainConfigurationType" : domainConfigurationType,
        "domainName" : domainName,
        "filteredSync" : filteredSync,
        "replicaSets" : replicaSets,
        "sku" : sku,
        "domainSecuritySettings": {
            "kerberosArmoring": "Disabled",
            "kerberosRc4Encryption": "Disabled",
            "ntlmV1": "Disabled",
            "syncKerberosPasswords": "Enabled",
            "syncNtlmPasswords": "Disabled",
            "syncOnPremPasswords": "Disabled",
            "tlsV1": "Disabled"
        },
        "ldapsSettings" : {
            "externalAccess" : "Disabled"
        }
      }
  /]

[/#macro]
