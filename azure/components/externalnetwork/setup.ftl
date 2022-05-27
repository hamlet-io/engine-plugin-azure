[#ftl]
[#macro azure_externalnetwork_arm_deployment_generationcontract occurrence ]
    [@addDefaultGenerationContract subsets=[ "template" ] /]
[/#macro]

[#macro azure_externalnetwork_arm_deployment occurrence ]
    [@debug message="Entering" context=occurrence enabled=false /]

    [#local parentCore = occurrence.Core ]
    [#local parentSolution = occurrence.Configuration.Solution ]
    [#local parentResources = occurrence.State.Resources ]

    [#local bgpSettings = {}]

    [#list (occurrence.Occurrences![])?filter(x -> x.Configuration.Solution.Enabled ) as subOccurrence]

        [@debug message="Suboccurrence" context=subOccurrence enabled=false /]

        [#local core = subOccurrence.Core ]
        [#local solution = subOccurrence.Configuration.Solution ]
        [#local resources = subOccurrence.State.Resources ]

        [#if !(solution.Enabled!false)]
            [#continue]
        [/#if]

        [#switch solution.Engine ]
            [#case "SiteToSite" ]
                [#local localConnections = (resources["localConnections"])!{} ]

                [#local vpnPublicIP = (solution.SiteToSite.PublicIP)!"" ]

                [#if ! vpnPublicIP?has_content ]
                    [@fatal
                        message="VPN Public IP Address not found"
                        context={ "SiteToSite" : solution.SiteToSite }
                    /]
                [/#if]

                [#local vpnSecurityProfile = getSecurityProfile(subOccurrence, "IPSecVPN")]
                [#local ipsecPolicies = {}]

                [#list vpnSecurityProfile.Phase1.EncryptionAlgorithms as ikeEncryption ]
                    [#list vpnSecurityProfile.Phase1.IntegrityAlgorithms as ikeIntegrity ]
                        [#list vpnSecurityProfile.Phase1.DiffeHellmanGroups as dhGroup ]
                            [#list vpnSecurityProfile.Phase2.EncryptionAlgorithms as ipsecEncryption ]
                                [#list vpnSecurityProfile.Phase2.IntegrityAlgorithms as ipsecIntegrity ]
                                    [#local ipsecPolicies += {
                                        formatName(ikeEncryption, ikeIntegrity, dhGroup, ipsecEncryption, ipsecIntegrity) : getAzNetworkConnectionIPSecPolicy(
                                            dhGroup,
                                            ikeEncryption,
                                            ikeIntegrity,
                                            ipsecEncryption,
                                            ipsecIntegrity,
                                            vpnSecurityProfile.Phase1.Lifetime
                                        )
                                    } ]
                                [/#list]
                            [/#list]
                        [/#list]
                    [/#list]
                [/#list]

                [#if vpnSecurityProfile["IKEVersions"]?size > 1 ]
                    [@fatal
                        message="Only one IKEVersion can be used at a time"
                        context={
                            "ProfileId" : solution.Profiles.Security,
                            "ProfileDetails" : vpnSecurityProfile
                        }
                    /]
                [/#if]


                [#if deploymentSubsetRequired(EXTERNALNETWORK_COMPONENT_TYPE, true)]

                    [#list localConnections?values as localConnection]

                        [#local localNetworkGateway = localConnection["localNetworkGateway"]]
                        [#local networkConnection = localConnection["networkConnection"] ]

                        [#if parentSolution.BGP.Enabled ]
                            [#local bgpSettings = getAzLocalNetworkGatewayBGP(
                                parentSolution.BGP.ASN,
                                solution.SiteToSite.BGP.PeerIPAddress
                            )]
                        [/#if]

                        [@createAzLocalNetworkGateway
                            id=localNetworkGateway.Id
                            name=localNetworkGateway.Name
                            gatewayIpAddress=vpnPublicIP
                            bgpSettings=bgpSettings
                            localNetworkAddresses=( ! parentSolution.BGP.Enabled)?then(
                                getGroupCIDRs(parentSolution.IPAddressGroups, true, subOccurrence),
                                [
                                    "${solution.SiteToSite.BGP.PeerIPAddress}/32"
                                ]
                            )
                            location=getRegion()
                            dependsOn=[]
                        /]

                        [@createAzNetworkConnection
                            id=networkConnection.Id
                            name=networkConnection.Name
                            location=getRegion()
                            connectionType="IPsec"
                            enableBGP=parentSolution.BGP.Enabled
                            routingWeight=subOccurrence?index
                            virtualGatewayReference=networkConnection.VirtualNetworkId
                            localNetworkReference=localNetworkGateway.Reference
                            sharedKey=solution.SiteToSite.SharedKey
                            connectionProtocol=vpnSecurityProfile["IKEVersions"][0]
                            ipsecPolicies=[ipsecPolicies?values[0]]
                            dependsOn=[
                                localNetworkGateway.Reference
                            ]
                        /]
                    [/#list]
                [/#if]
                [#break]
        [/#switch]
    [/#list]
[/#macro]
