[#ftl]
[#include "openapi.ftl"]

[@addResourceGroupInformation
    type=APIGATEWAY_COMPONENT_TYPE
    attributes=[
        {
            "Names" : "ContentType",
            "Description" : "The content type of the API's schema",
            "Type" : STRING_TYPE,
            "Default" : "application/vnd.oai.openapi.components+json"
        },
        {
            "Names": "Contact",
            "Description" : "The contact for the API Management Service",
            "Children" : [
                {
                    "Names" : "Name",
                    "Type": STRING_TYPE
                },
                {
                    "Names" : "Email",
                    "Type" : STRING_TYPE
                }
            ]
        },
        {
            "Names" : "FrontDoor",
            "Children": [
                {
                    "Names" : "Mapping",
                    "Type" : BOOLEAN_TYPE,
                    "Default" : false
                }
            ]
        }
    ]
    provider=AZURE_PROVIDER
    resourceGroup=DEFAULT_RESOURCE_GROUP
    services=
        [
            AZURE_API_MANAGEMENT_SERVICE,
            AZURE_STORAGE_SERVICE,
            AZURE_KEYVAULT_SERVICE
        ]
/]