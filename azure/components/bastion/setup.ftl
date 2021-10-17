[#ftl]
[#macro azure_bastion_arm_deployment_generationcontract occurrence]
  [@addDefaultGenerationContract subsets=[ "template", "parameters"] /]
[/#macro]

[#macro azure_bastion_arm_deployment occurrence]

  [@debug message="Entering Bastion Setup" context=occurrence enabled=false /]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]
  [#local resources = occurrence.State.Resources]
  [#local autoScaleConfig = solution.AutoScaling]

  [#-- Network Lookups & Links --]
  [#-- As full subnet name is vnet/subnet, retrieve both & format --]
  [#local occurrenceNetwork = getOccurrenceNetwork(occurrence)]
  [#local networkLink = occurrenceNetwork.Link!{} ]
  [#local networkLinkTarget = getLinkTarget(occurrence, networkLink, false) ]

  [#if ! networkLinkTarget?has_content ]
      [@fatal message="Network could not be found" context=networkLink /]
      [#return]
  [/#if]

  [#local networkResources = networkLinkTarget.State.Resources ]
  [#local networkVnetResource = networkResources["vnet"]]
  [#local subnetResource = getSubnet(core.Tier, networkResources)]
  [#local subnetName = formatAzureResourceName(
    subnetResource.Name,
    getResourceType(subnetResource.Id),
    networkVnetResource.Name
  )]
  [#local subnetReference = getReference(subnetResource.Id)]

  [#-- Baseline Component Lookup --]
  [#local baselineLinks = getBaselineLinks(occurrence, ["SSHKey"], false, false)]
  [#local baselineAttributes = baselineLinks["SSHKey"].State.Attributes]
  [#local baselineResources = baselineLinks["SSHKey"].State.Resources]
  [#local sshKey = baselineResources["vmKeyPair"]]
  [#local sshPublicKeyParameterName = sshKey.Name + "PublicKey"]

  [#-- Resources                                        --]
  [#-- Add Reference Attribute to all for simple lookup --]
  [#local prefix = resources["publicIPPrefix"]]
  [#local nic = resources["networkInterface"]]
  [#local scaleSet = resources["scaleSet"]]
  [#local autoScalePolicy = resources["autoScalePolicy"]]
  [#local nsg = resources["networkSecurityGroup"]]
  [#local nsgRules = resources["nsgRules"]]

  [#-- Public IP --]
  [@createPublicIPAddressPrefix
    id=prefix.Id
    name=prefix.Name
    location=getRegion()
    prefixLength=31
  /]

  [#-- VM Scale Set --]
  [#local vmssProcessorProfile = getProcessor(occurrence, BASTION_COMPONENT_TYPE)]]
  [#local vmssProcessor = vmssProcessorProfile.Processor]
  [#local vmssProcessorTier = vmssProcessor?split("_")[0]]
  [#local vmssVMImageProfile = getVMImageProfile(occurrence, core.Type)]
  [#local vmssVMAdminName = BASTION_COMPONENT_TYPE]

  [#if deploymentSubsetRequired("parameters", true)]

      [@createKeyVaultParameterLookup
        secretName=sshPublicKeyParameterName
        vaultId=baselineAttributes["KEYVAULT_ID"]
      /]

  [/#if]
  [#local vmssVMOSConfig = getVirtualMachineProfileLinuxConfig(
    [
      getVirtualMachineProfileLinuxConfigPublicKey(
      "/home/" + vmssVMAdminName + "/.ssh/authorized_keys",
        getParameterReference(sshPublicKeyParameterName)
      )
    ],
    true
  )]

  [#-- IP Config that references the existing NIC and IP Prefix --]
  [#local nicIPReference = getIPConfiguration(
      "default",
      subnetReference,
      true,
      "",
      "default",
      15,
      [],
      "IPv4",
      prefix.Reference
      "", "", ""
  )]

  [#local vmssVMNICConfig = getVirtualMachineNetworkProfileNICConfig(
    nic.Reference,
    nic.Name,
    nicIPReference.properties.primary,
    [nicIPReference],
    nsg.Reference
  )]

  [#local vmssVMNetworkProfile = getVirtualMachineNetworkProfile([vmssVMNICConfig])]
  [#local vmssVMSkuProfile = getSkuProfile(occurrence, core.Type)]

  [#local vmssVMProfile = getVirtualMachineProfile(
    "Standard_LRS",
    vmssVMImageProfile.Publisher,
    vmssVMImageProfile.Offering,
    vmssVMImageProfile.Image,
    vmssVMNetworkProfile,
    vmssVMOSConfig,
    core.Type,
    vmssVMAdminName
  )]

  [@createVMScaleSet
    id=scaleSet.Id
    identity={"type": "SystemAssigned"}
    name=scaleSet.Name
    location=getRegion()
    skuName=vmssVMSkuProfile.Name
    skuTier=vmssVMSkuProfile.Tier
    skuCapacity=solution.Active?then(1,0)
    vmProfile=vmssVMProfile
    dependsOn=
      [
        nsg.Reference
      ]
  /]

  [@createNetworkSecurityGroup
    id=nsg.Id
    name=nsg.Name
    location=getRegion()
  /]

  [#if (solution.IPAddressGroups)?has_content ]
    [#list nsgRules as id, rule]

      [@createNetworkSecurityGroupSecurityRule
          id=rule.Id
          name=rule.Name
          access="allow"
          direction="Inbound"
          sourceAddressPrefixes=getGroupCIDRs(solution.IPAddressGroups, true, occurrence)
          destinationAddressPrefix="*"
          destinationPortProfileName=rule.Port
          priority=200 + rule?index
          dependsOn=[
            nsg.Reference
          ]
      /]

    [/#list]
  [/#if]

[/#macro]
