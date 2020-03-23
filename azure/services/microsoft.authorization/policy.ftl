[#ftl]

[#-- global lookup for user Role names and ids.             --]
[#-- Custom Roles append to this on creation.               --]
[#-- BuiltInRoles to be added as they are utilised in cot.  --]
[#-- https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles --]
[#assign userRoles = {
    "Reader" : {
        "Description" : "Lets you view everything, but not make any changes.",
        "RoleType" : "BuiltInRole",
        "Id" : "acdd72a7-3385-48ef-bd42-f606fba81ae7"
    }
}]

[#-- For retrieving BuiltInRole definitions only.             --]
[#-- CustomRole definition references should be obtained      --]
[#-- through occurrence.State.Resources[<resource>].Reference --]
[#function getRoleReference role subscription=""]
    [#local userRole = userRoles[role]]
    [#return
        getReference(
            AZURE_ROLE_ASSIGNMENT_RESOURCE_TYPE,
            userRole.Id,
            "",
            REFERENCE_ATTRIBUTE_TYPE,
            subscription
        )
    ]
[/#function]