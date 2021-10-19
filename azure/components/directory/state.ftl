[#ftl]

[#macro azure_directory_arm_state occurrence parent={} ]
    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]

    [#local directoryId = formatResourceId(AZURE_AAD_DIRECTORY_SERVICES_RESOURCE_TYPE, core.Id)]
    [#local directoryName = formatAzureResourceName(core.FullName, getResourceType(directoryId))]

    [#local certificateObject = getCertificateObject(solution.Hostname!"")]
    [#local certificateDomains = getCertificateDomains(certificateObject) ]
    [#local primaryDomainObject = getCertificatePrimaryDomain(certificateObject) ]
    [#local hostName = getHostName(certificateObject, occurrence) ]
    [#local fqdn = formatDomainName(hostName, primaryDomainObject) ]

    [#assign componentState =
        {
            "Resources" : {
                "directory" : {
                    "Id" : directoryId,
                    "Name" : directoryName,
                    "Type" : AZURE_AAD_DIRECTORY_SERVICES_RESOURCE_TYPE,
                    "Reference" : getReference(directoryId, directoryName),
                    "DomainName" : fqdn
                }
            },
            "Attributes" : {
                "DOMAIN_NAME" : fqdn
            },
            "Roles" : {
                "Inbound" : {},
                "Outbound" : {}
            }
        }
    ]
[/#macro]
