[#ftl]

[@addReferenceData 
    type=VIRTUAL_MACHINE_IMAGE_REFERENCE_TYPE
    base=blueprintObject 
/]

[#function getVMImageProfile occurrence type extensions... ]	
    [#local vmImageProfiles = 
        getReferenceData(VIRTUAL_MACHINE_IMAGE_REFERENCE_TYPE)]
    [#local tc = formatComponentShortName(	
                    occurrence.Core.Tier,	
                    occurrence.Core.Component,	
                    extensions)]
    [#local defaultProfile = "default"]	
    [#if (vmImageProfiles[defaultProfile][tc])??]	
        [#return vmImageProfiles[defaultProfile][tc]]	
    [/#if]	
    [#if (vmImageProfiles[defaultProfile][type])??]	
        [#return vmImageProfiles[defaultProfile][type]]	
    [/#if]	
[/#function]