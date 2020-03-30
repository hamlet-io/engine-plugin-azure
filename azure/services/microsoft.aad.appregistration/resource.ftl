[#ftl]

[@addResourceProfile
    service=AZURE_AAD_APP_REGISTRATION_PSEUDO_SERVICE
    resource=AZURE_APPLICATION_REGISTRATION_RESOURCE_TYPE
    profile=
        {
            "apiVersion" : "pseudo",
            "type" : "pseudo",
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property": "id"
                }
            }
        }
/]

[@addResourceProfile
    service=AZURE_AAD_APP_REGISTRATION_PSEUDO_SERVICE
    resource=AZURE_AUTHENTICATION_PROVIDER_RESOURCE_TYPE
    profile=
        {
            "apiVersion" : "pseudo",
            "type" : "pseudo",
            "outputMappings" : {}
        }
        
/]