[#ftl]

[@addResourceProfile
    service=AZURE_AUTHORIZATION_SERVICE
    resource=AZURE_ROLE_ASSIGNMENT_RESOURCE_TYPE
    profile=
        {
            "apiVersion" : "2018-09-01-preview",
            "type" : "Microsoft.Authorization/roleAssignments",
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                }
            }
        }
/]

[@addResourceProfile
    service=AZURE_AUTHORIZATION_SERVICE
    resource=AZURE_ROLE_DEFINITION_RESOURCE_TYPE
    profile=
        {
            "apiVersion": "2018-01-01-preview",
            "type": "Microsoft.Authorization/roleDefinitions",
            "outputMappings" : {
                REFERENCE_ATTRIBUTE_TYPE : {
                    "Property" : "id"
                }
            }
        }
/]

[#macro createRoleDefinition
    id
    name
    roleName=""
    roleDescription=""
    actions=[]
    notActions=[]
    dataActions=[]
    notDataActions=[]
    assignableScopes=[]
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_ROLE_DEFINITION_RESOURCE_TYPE
        dependsOn=dependsOn
        properties=
            {
                "roleType" : "customRole"
            } +
            attributeIfContent("roleName", roleName) +
            attributeIfContent("description", roleDescription) +
            attributeIfContent("permissions", 
                attributeIfContent("actions", actions) +
                attributeIfContent("notActions", notActions) +
                attributeIfContent("dataActions", dataActions) +
                attributeIfContent("notDataActions", notDataActions)
            ) +
            attributeIfContent("assignableScopes", assignableScopes)
    /]

[/#macro]

[#macro createRoleAssignment
    id
    name
    roleDefinitionId
    principalId
    principalType=""
    canDelegate=false
    dependsOn=[]]

    [@armResource
        id=id
        name=name
        profile=AZURE_ROLE_ASSIGNMENT_RESOURCE_TYPE
        dependsOn=dependsOn
        properties=
            {
                "roleDefinitionId" : roleDefinitionId,
                "principalId" : principalId
            } +
            attributeIfContent("principalType", principalType) +
            attributeIfTrue("canDelegate", canDelegate, canDelegate)
    /]

[/#macro]