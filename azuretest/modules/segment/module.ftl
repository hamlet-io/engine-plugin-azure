[#ftl]

[@addModule
    name="segment"
    description="Standard segment level outputs for higher level components"
    provider=AZURETEST_PROVIDER
    properties=[]
/]

[#macro azuretest_module_segment ]

    [@loadModule
        settingSets=[]
        blueprint={}
        stackOutputs=[
            {
                "Account": AZURE_SUBSCRIPTION_MOCK_VALUE,
                "Region": AZURE_REGION_MOCK_VALUE,
                "DeploymentUnit": "baseline",

                "seedXsegment": "568132487",

                "keyXcmk": "cmk-123-def-456",
                "secretXssh": "ssh-123-def-456",


                "containerXmgmtXbaselineXopsdata": "/subscriptions/${AZURE_SUBSCRIPTION_MOCK_VALUE}/resourceGroups/office-production-directory-seg-baseline/providers/Microsoft.Storage/storageAccounts/mgmtbaseline107091004910/blobServices/default/containers/opsdata",
                "containerXmgmtXbaselineXappdata": "/subscriptions/${AZURE_SUBSCRIPTION_MOCK_VALUE}/resourceGroups/office-production-directory-seg-baseline/providers/Microsoft.Storage/storageAccounts/mgmtbaseline107091004910/blobServices/default/containers/appdata",
                "storageXmgmtXbaseline": "/subscriptions/${AZURE_SUBSCRIPTION_MOCK_VALUE}/resourceGroups/office-production-directory-seg-baseline/providers/Microsoft.Storage/storageAccounts/mgmtbaseline107091004910"
            },
            {
                "Account": AZURE_SUBSCRIPTION_MOCK_VALUE,
                "Region": AZURE_REGION_MOCK_VALUE,
                "DeploymentUnit": "vpc",

                "vnetXmgmtXvpc": "vnet123",

                "subnetsXmgmt": "subnetmgmt",
                "subnetsXdir": "subnetdir",
                "subnetsXweb": "subnetweb",
                "subnetsXdb": "subnetdb",
                "subnetsXapp": "subnetapp",
                "subnetsXapi": "subnetapi",
                "subnetsXelb": "subnetelb",

                "nsgXvnetXmgmtXvpcXmgmtXvpcXPublic": "nsgPublic",
                "nsgXvnetXmgmtXvpcXmgmtXvpcXPrivate": "nsgPrivate",
                "nsgXvnetXmgmtXvpcXmgmtXvpcXLBPrivate": "nsgPrivate",
                "nsgXvnetXmgmtXvpcXmgmtXvpcXLBPublic": "nsgLBPublic",
                "nsgXvnetXmgmtXvpcXmgmtXvpcXDirectoryPrivate": "nsgDirectoryPrivate"
            }
        ]
        commandLineOption={}
    /]

[/#macro]
