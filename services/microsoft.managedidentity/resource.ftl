[#ftl]

[@addResourceProfile
    service=AZURE_IAM_SERVICE
    resource=AZURE_USER_ASSIGNED_IDENTITY_RESOURCE_TYPE
    profile=
        {
            "apiVersion" : "2018-11-30",
            "type" : "Microsoft.ManagedIdentity/userAssignedIdentities",
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                }
            }
        }
/]

[#macro createUserAssignedIdentity
    id
    name
    location=""
    dependsOn=[]
    tags={}]

    [@armResource
        id=id
        name=name
        profile=AZURE_USER_ASSIGNED_IDENTITY_RESOURCE_TYPE
        location=location
        dependsOn=dependsOn
        properties={}
        tags=tags
    /]
[#/macro]
