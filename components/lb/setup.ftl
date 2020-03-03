[#ftl]

[#macro azure_lb_arm_genplan_solution occurrence]
    [@addDefaultGenerationPlan subsets=["template"] /]
[/#macro]

[#macro azure_lb_arm_setup_solution occurrence]
    [@debug message="Entering LB Setup" context=occurrence enabled=true /]

    [#local core = occurrence.Core]
    [#local solution = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#local engine = solution.Engine]
    
    [#local lb = resources["lb"]]
    [#local publicIP = resources["publicIP"]]

    [#local listenerPortsSeen = []]
    [#local portProtocols = []]
    [#local gatewayIPConfigurations = []]
    [#local frontendIPConfigurations = []]
    [#local frontendPorts = []]
    [#local backendAddressPools = []]
    [#local backendHttpSettingsCollections = []]
    [#local httpListeners = []]
    [#local requestRoutingRules = []]
    [#local redirectConfigurations = []]

    [#list occurrence.Occurrences![] as subOccurrence]

        [#local subCore = subOccurrence.Core]
        [#local subSolution = subOccurrence.Configuration.Solution]
        [#local subResources = subOccurrence.State.Resources]

        [#local listener = subResources["listener"]]
        [#local frontendPort = subResources["frontendPort"]]
        [#local frontendIPConfiguration = subResources["frontendIPConfiguration"]]
        [#local gatewayIPConfiguration = subResources["gatewayIPConfiguration"]]
        [#local routingRule = subResources["routingRule"]]
        [#local backendSettingsCollection = subResources["backendSettingsCollection"]]
        [#local backendAddressPool = subResources["backendAddressPool"]]
        [#local redirectConfiguration = subResources["redirectConfiguration"]!{}]

        [#-- Check source and destination ports --]
        [#local mapping = solution.Mapping!subCore.SubComponent.Name]
        [#local source = (portMappings[mapping].Source)!""]
        [#local destination = (portMappings[mapping].Destination)!""]
        [#local sourcePort = (ports[source])!{}]
        [#local destinationPort = (ports[destination])!{}]

        [#if !(sourcePort?has_content && destinationPort?has_content)]
            [#continue]
        [/#if]
        [#local portProtocols += [ sourcePort.Protocol ]]
        [#local portProtocols += [ destinationPort.Protocol]]

        [#-- Certificate details if required --]
        [#local certificateObject = getCertificateObject(
            subSolution.Certificate,
            segmentQualifiers,
            sourcePort.Id!source,
            sourcePort.Name!source
        )]
        [#local hostName = getHostName(certificateObject, subOccurrence)]
        [#local primaryDomainObject = getCertificatePrimaryDomain(certificateObject)]

        [#-- Determine if this is the first mapping for the source port --]
        [#-- The assumption is that all mappings for a given port share --]
        [#-- the same listenerId, so the same port number shouldn't be  --]
        [#-- defined with different names                               --]
        [#local firstMappingForPort = !listenerPortsSeen?seq_contains(listener.Id)]
        [#switch engine]
            [#case "application"]
                [#if subSolution.Path != "default" ]
                    [#-- Only create the listener for default mappings      --]
                    [#-- The ordering of ports changes with their naming    --]
                    [#-- so it isn't sufficient to use the first occurrence --]
                    [#-- of a listener                                      --]
                    [#local firstMappingForPort = false]
                [/#if]
                [#break]
        [/#switch]
        [#if firstMappingForPort]
            [#local listenerPortsSeen += [listener.Id]]

            [#switch engine]
                [#case "application"]

                    [#local frontendIPConfigurations += [
                        getAppGatewayFrontendIPConfiguration(
                            frontendIPConfiguration.Name,
                            publicIP.Id
                        )
                    ]]

                    [#local frontendPorts += [
                        getAppGatewayFrontendPort(frontendPort.Name, sourcePort.Port)
                    ]]

                    [#local httpListeners += [
                        getAppGatewayHttpListener(
                            listener.Name,
                            frontendIPConfiguration.SubReference,
                            frontendPort.SubReference,
                            sourcePort.Protocol,
                            hostName
                        )]]

                    [#break]
            [/#switch]

        [/#if]

    [/#list]

    [#switch engine]
        [#case "application"]

            [@createPublicIPAddress
                id=publicIP.Id,
                name=publicIP.Name,
                location=regionId
                allocationMethod="Dynamic"
            /]

            [@createApplicationGateway
                id=lb.Id
                name=lb.Name
                location=regionId
                skuName=lb.Sku
                skuTier=lb.Sku
                gatewayIPConfigurations=gatewayIPConfigurations
                frontendIPConfigurations=frontendIPConfigurations
                frontendPorts=frontendPorts
                backendAddressPools=backendAddressPools
                backendHttpSettingsCollection=backendHttpSettingsCollections
                httpListeners=httpListeners
                requestRoutingRules=requestRoutingRules
                redirectConfigurations=redirectConfigurations
            /]
            [#break]

        [#default]
            [@fatal
                message="Unsupported engine type"
                context=
                    {
                        "LB" : lb.Name,
                        "Engine" : engine
                    }
            /]
            [#break]

    [/#switch]

[/#macro]