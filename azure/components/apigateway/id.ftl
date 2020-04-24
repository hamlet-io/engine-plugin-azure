[#ftl]
[#include "openapi.ftl"]

[@addResourceGroupInformation
    type=APIGATEWAY_COMPONENT_TYPE
    attributes=[
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