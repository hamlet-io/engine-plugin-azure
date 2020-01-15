[#ftl]
[#macro azure_bastion_arm_genplan_segment occurrence]
  [@addDefaultGenerationPlan subsets=[ "template", "parameters"] /]
[/#macro]

[#macro azure_bastion_arm_setup_segment occurrence]

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
  [#local mgmtSubnetResource = networkResources["subnets"]["mgmt"]["subnet"]]
  [#local mgmtSubnetName = formatAzureResourceName(
    mgmtSubnetResource.Name,
    getResourceType(mgmtSubnetResource.Id),
    networkVnetResource.Name
  )]

  [#-- Baseline Component Lookup --]
  [#local baselineLinks = getBaselineLinks(occurrence, ["SSHKey"])]
  [#local baselineComponentIds = getBaselineComponentIds(baselineLinks, "cmk", "vmKeyPair")]

  [#-- Public IP --]
  [@createPublicIPAddress
    id=resources["publicIP"].Id
    name=resources["publicIP"].Name
    location=regionId 
  /]

  [#-- NIC --]
  [#local nicIpConfiguration = getIPConfiguration(
    "default",
    getReference(mgmtSubnetResource.Id, mgmtSubnetName),
    true,
    getReference(resources["publicIP"].Id, resources["publicIP"].Name)
  )]

  [@createNetworkInterface
    id=resources["networkInterface"].Id
    name=resources["networkInterface"].Name
    location=regionId
    nsgId=getReference(
      networkResources["networkSecurityGroup"].Id,
      networkResources["networkSecurityGroup"].Name)
    ipConfigurations=[nicIpConfiguration]
    dependsOn=
      [
        getReference(resources["publicIP"].Id, resources["publicIP"].Name)
      ]
  /]

  [#-- VM Scale Set --]
  [#local vmssProcessorProfile = processors[solution.Profiles.Processor]]
  [#local vmssProcessorType = vmssProcessorProfile[core.Type]]
  [#local vmssProcessor = vmssProcessorType.Processor]
  [#local vmssProcessorTier = vmssProcessor?split("_")[0]]
  [#local vmssVMImageProfile = vmImageProfiles[BASTION_COMPONENT_TYPE]]
  [#local vmssVMAdminName = BASTION_COMPONENT_TYPE]

  [#if deploymentSubsetRequired("parameters", false)]
      [@addParametersToDefaultJsonOutput
        id=baselineComponentIds["ssh"]
        parameter=getKeyVaultParameter(
          baselineLinks[0].State.Resources["keyVault"].Id, 
          baselineComponentIds["ssh"]
        )
      /]
  [/#if]
  [#local vmssVMOSConfig = getVirtualMachineProfileLinuxConfig(
    [
      getVirtualMachineProfileLinuxConfigPublicKey(
        "/home/" + vmssVMAdminName + "/.ssh_authorized_keys",
        getParameterReference(baselineComponentIds["ssh"])
      )
    ],
    true
  )]

  [#local vmssVMProfile = getVirtualMachineProfile(
    core.Type,
    vmssVMAdminName,
    "Standard_LRS",
    vmssVMImageProfile.Publisher,
    vmssVMImageProfile.Offering,
    vmssVMImageProfile.SKU,
    [{ 
      "name" : resources["networkInterface"].Name,
      "id" : getReference(
      resources["networkInterface"].Id,
      resources["networkInterface"].Name) 
    }],
    vmssVMOSConfig
  )]

  [@createVMScaleSet
    id=resources["scaleSet"].Id
    identity={"type": "SystemAssigned"}
    name=resources["scaleSet"].Name
    location=regionId
    skuName=vmssProcessor
    skuTier=vmssProcessorTier
    skuCapacity=autoScaleConfig.MinUpdateInstances
    vmProfile=vmssVMProfile
  /]
  

  [#-- AutoScale Policy --]
  [#if autoScaleConfig.Enabled]

    [#-- TODO: rossmurr4y
    Add autoscaling configuration for the VMSS.
    
    [#local autoScaleTargetId = getReference(
      resources["scaleSet"].Id,
      resources["scaleSet"].Name)]

    [#local autoScaleRule = getAutoScaleRule()]

    [#local autoScaleProfile = getAutoScaleProfile(
      "scale-to-zero-when-unused",
      autoScaleConfig.MinUpdateInstances,
      "1",
      autoScaleConfig.MinUpdateInstances,
      [autoScaleRule])]
      
    [@createAutoscaleSettings
      id=resources["autoScalePolicy"].Id
      name=resources["autoScalePolicy"].Name
      location=regionId
      targetId=autoScaleTargetId
      profiles=[autoScaleProfile]
      enabled=autoScaleConfig.Enabled
      dependsOn=
        [
          autoScaleTargetId
        ]
    /]
    --]
  [/#if]

  [#-- NSG Rule - Allow SSH Inbound --]

[/#macro]