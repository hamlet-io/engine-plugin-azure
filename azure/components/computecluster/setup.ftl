[#ftl]

[#macro azure_computecluster_arm_generationcontract_application occurrence ]
    [@addDefaultGenerationContract subsets="template" /]
[/#macro]

[#macro azure_computecluster_arm_setup_application occurrence]
    [@debug message="Entering" context=occurrence enabled=true /]

    [#local core      = occurrence.Core]
    [#local solution  = occurrence.Configuration.Solution]
    [#local resources = occurrence.State.Resources]

    [#-- Resources --]
    [#local scaleSet      = resources["scaleSet"]]
    [#local nic           = resources["networkInterface"]]
    [#local nsgRule       = resources["nsgRule"]]
    [#local ipPrefix      = resources["publicIPPrefix"]]
    [#local scalePolicies = resources["scalePolicies"]]

    [#-- Profiles --]
    [#local sku     = getSkuProfile(occurrence, core.Type)]
    [#local vmImage = getVMImageProfile(occurrence, core.Type)]
    [#local vmStorage = getStorage(occurrence, core.Type)]

    [#-- Baseline Lookup --]

    [#-- Links --]

    [#-- App Config --]

    [#-- Ports --]

    [#-- Scaling Policies --]

    [#-- Network Security Group --]

    [#local vmProfile = 
        getVirtualMachineProfile(
            storageAccountType=[vmStorage.Tier, vmStorage.Replication]?join('_')
            imagePublisher=vmImage.Publisher
            imageOffer=vmImage.Offer
            nicConfigurations=
        )
    ]

    [@createVMScaleSet
        id=scaleSet.Id
        name=scaleSet.Name
        identity={"type": "SystemAssigned"}
        location=regionId
        skuName=sku.Name
        skuTier=sku.Tier
        skuCapacity=sku.Capacity
        vmProfile=vmProfile
        dependsOn=[]
    /]

[/#macro]
