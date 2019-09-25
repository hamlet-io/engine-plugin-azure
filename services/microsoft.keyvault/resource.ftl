[#ftl]

[#assign AZURE_KEYVAULT_OUTPUT_MAPPINGS = 
  {
    REFERENCE_ATTRIBUTE_TYPE : {
      "Property" : "id"
    }
  }
]

[#-- TODO - do i need more attribute types here? KEY_ATTRIBUTE_TYPE? --]
[#assign AZURE_KEYVAULT_SECRET_OUTPUT_MAPPINGS =
  {
    REFERENCE_ATTRIBUTE_TYPE : {
      "Property" : "id"
    }
  }
]

[#assign outputMappings +=
  {
    AZURE_KEYVAULT_RESOURCE_TYPE : AZURE_KEYVAULT_OUTPUT_MAPPINGS,
    AZURE_KEYVAULT_SECRET_RESOURCE_TYPE : AZURE_KEYVAULT_SECRET_OUTPUT_MAPPINGS
  }
]

[#fuction getKeyVaultSku family name]
  [#-- SKU for a KeyVault resides within the Properties object,
  not at the top level object depth as exists in the ARM schema. --]
  [#return
    {
      "family" : family,
      "name" : name
    }
  ]
[/#function]

[#-- AccessPolicy can be defined as either a property on the KeyVault resource,
or as a sub-resource. Both utilise this function, however this naming
convention ("object" suffix) is used to easily distinguish the two. --]
[#function getKeyVaultAccessPolicyObject
  tenantId
  objectId
  permissions
  applicationId=""]

  [#return
    {
      "tenantId" : tenantId,
      "objectId" : objectId,
      "permissions" : permissions
    } + 
    attributeIfContent("applicationId", applicationId)
  ]

[/#function]

[#function getKeyVaultAccessPolicyPermissions
  keys=[]
  secrets=[]
  certificates=[]
  storage=[]]
  [#return
    {} +
    attributeIfContent("keys", asArray(keys)) +
    attributeIfContent("secrets", asArray(secrets)) +
    attributeIfContent("certificates", asArray(certificates)) +
    attributeIfContent("storage", asArray(storage))
  ]
[/#function]

[#function getKeyVaultProperties
  tenantId
  sku
  accessPolicies=[]
  uri=""
  enabledForDeployment=false
  enabledForDiskEncryption=false
  enabledForTemplateDeployment=false
  enableSoftDelete=false
  createMode=false
  enablePurgeProtection=false
  networkAcls={}]

  [#return
    {
      "tenantId" : tenantId,
      "sku" : sku
    } +
    attributeIfContent("accessPolicies", accessPolicies) +
    attributeIfContent("vaultUri", uri) +
    attributeIfTrue("enabledForDeployment", enabledForDeployment) +
    attributeIfTrue("enabledForDiskEncryption", enabledForDiskEncryption) +
    attributeIfTrue("enabledForTemplateDeployment", enabledForTemplateDeployment) +
    attributeIfTrue("enableSoftDelete", enableSoftDelete) +
    attributeIfTrue("createMode", createMode) +
    attributeIfTrue("enablePurgeProtection", enablePurgeProtection) +
    attributeIfContent("networkAcls", networkAcls)
  ]

[/#function]

[#function getKeyVaultSecretAttributes
  notBeforeDate
  expiryDate
  enabled=false]

  [#return
    {} +
    attributeIfTrue("enabled", enabled) +
    attributeIfContent("nbf", notBeforeDate) +
    attributeIfContent("exp", expiryDate)
  ]
[/#function]

[#function getKeyVaultSecretProperties
  value=""
  contentType=""
  attributes={}]

  [#return
    {} +
    attributeIfContent("value", value) +
    attributeIfContent("contentType", contentType) +
    attributeIfContent("attributes", attributes)
  ]

[/#function]

[#macro createKeyVault
  name
  location
  tenantId
  sku
  properties
  tags={}
  resources=[]
  dependsOn=[]]

  [@armResource
    name=name
    type="Microsoft.KeyVault/vaults"
    apiVersion="2018-02-14"
    location=location
    properties=properties
    tags=tags
    sku=sku
    resources=resources
    outputs=AZURE_KEYVAULT_OUTPUT_MAPPINGS
    dependsOn=dependsOn
  ]

[/#macro]

[#macro createKeyVaultAccessPolicy name properties]

  [@armResource
    name=name
    type="Microsoft.KeyVault/vaults/accessPolicies"
    apiVersion="2018-02-14"
    properties=properties
  ]

[/#macro]

[#macro createKeyVaultSecret
  name
  tags={}
  properties={}]

  [@armResource
    name=name
    type="Microsoft.KeyVault/vaults/secrets"
    apiVersion="2018-02-14"
    tags=tags
    outputs=AZURE_KEYVAULT_SECRET_OUTPUT_MAPPINGS
    properties=properties
  ]
[/#macro]
