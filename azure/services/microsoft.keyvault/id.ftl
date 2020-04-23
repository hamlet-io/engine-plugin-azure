[#ftl]

[#-- Resources --]
[#assign AZURE_KEYVAULT_RESOURCE_TYPE = "vault"]
[#assign AZURE_KEYVAULT_SECRET_RESOURCE_TYPE = "secret"]
[#assign AZURE_KEYVAULT_ACCESS_POLICY_RESOURCE_TYPE = "vaultAccessPolicy"]

[#assign AZURE_CMK_RESOURCE_TYPE = "cmk"]

[#assign LOCAL_SSH_PRIVATE_KEY_RESOURCE_TYPE = "sshPrivKey"]


[#-- Attribute Type --]
[#-- The "secret" attribute type is an identifier for a KeyVault Secret. --]
[#-- This is necessary to distinguish them from encrypted passwords.     --]
[#assign SECRET_ATTRIBUTE_TYPE = "secret"]