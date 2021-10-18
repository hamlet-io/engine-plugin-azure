[#ftl]

[@addReferenceData
    type=SKU_PROFILE_REFERENCE_TYPE
    base=blueprintObject
/]

[#function getSkuProfile occurrence type extensions... ]
    [#local skuProfiles = getReferenceData(SKU_PROFILE_REFERENCE_TYPE)]
    [#local tc = formatComponentShortName(
                    occurrence.Core.Tier,
                    occurrence.Core.Component,
                    extensions)]
    [#local defaultProfile = "default"]
    [#if (skuProfiles[defaultProfile][tc])??]
        [#return skuProfiles[defaultProfile][tc]]
    [/#if]
    [#if (skuProfiles[defaultProfile][type])??]
        [#return skuProfiles[defaultProfile][type]]
    [/#if]
[/#function]
