[#ftl
]
[#-- Structure --]

[#-- TODO(rossmurr4y): ensure Storage service is using this. --]
[#function getNetworkAcls 
    defaultAction 
    ipRules=[]
    virtualNetworkRules=[]
    bypass=""]

    [#return
        {
            "defaultAction": defaultAction
        } +
        attributeIfContent("ipRules", asArray(ipRules)) +
        attributeIfContent("virtualNetworkRules", asArray(virtualNetworkRules)) +
        attributeIfContent("bypass", bypass)
    ]
[/#function]