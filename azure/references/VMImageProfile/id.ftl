[#ftl]

[@addReference 
    type=VIRTUAL_MACHINE_IMAGE_REFERENCE_TYPE
    pluralType="VMImageProfiles"
    properties=[
            {
                "Type"  : "Description",
                "Value" : "A virtual machine operating system configuration" 
            }
        ]
    attributes=[
        {
            "Names" : "*",
            "Description" : "The component type that the VMImage configuration belongs to.",
            "Children" : [
                {
                    "Names" : "Publisher",
                    "Types" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "Offering",
                    "Types" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "Image",
                    "Types" : STRING_TYPE,
                    "Mandatory" : true
                },
                {
                    "Names" : "LicenseType",
                    "Types" : STRING_TYPE,
                    "Mandatory" : false
                }
            ]
        }
    ]
/]