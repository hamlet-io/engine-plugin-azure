[#ftl]

[#macro azure_network_arm_state occurrence parent={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#local vnetId = formatVirtualNetworkId(core.Id)]
  [#local vnetName = core.ShortTypedFullName]

  [#local networkCIDR = isPresent(network.CIDR)?then(
    network.CIDR.Address + "/" + network.CIDR.Mask,
    solution.Address.CIDR )]

  [#local networkAddress = networkCIDR?split("/")[0]]
  [#local networkMask = (networkCIDR?split("/")[1])?number]

  [#local subnetCIDRMask = getSubnetMaskFromSizes(
    networkCIDR,
    network.Tiers.Order?size)]

  [#local subnetCIDRs = getSubnetsFromNetwork(
    networkCIDR,
    subnetCIDRMask)]

  [#-- Define subnets /w routeTableRoutes --]
  [#local subnets = {}]
  [#local routeTableRoutes = {}]
  [#list segmentObject.Network.Tiers.Order as tierId]

    [#local networkTier = getTier(tierId) ]
    [#-- Filter out to only valid tiers --]
    [#if ! (networkTier?has_content &&
            networkTier.Network.Enabled &&
            networkTier.Network.Link.Tier == core.Tier.Id &&
            networkTier.Network.Link.Component == core.Component.Id &&
            (networkTier.Network.Link.Version!core.Version.Id) == core.Version.Id &&
            (networkTier.Network.Link.Instance!core.Instance.Id) == core.Instance.Id)]
      [#continue]
    [/#if]

    [#local subnetId = formatDependentResourceId(AZURE_SUBNET_RESOURCE_TYPE, networkTier.Id)]
    [#local resourceProfile = getAzureResourceProfile(AZURE_SUBNET_RESOURCE_TYPE)]

    [#local subnets = mergeObjects(
      subnets,
      {
        networkTier.Id : {
          "subnet": {
            "Id": subnetId,
            "Name": networkTier.Name,
            "Address": subnetCIDRs[tierId?index],
            "Type": AZURE_SUBNET_RESOURCE_TYPE,
            "Reference" : getReference(subnetId, networkTier.Name)
          }
        }
      }
    )]

    [#local routeTableRoutes = mergeObjects(
      routeTableRoutes,
      {
        networkTier.Id : {
          "routeTableRoute" : {
            "Id" : formatDependentResourceId(AZURE_ROUTE_TABLE_ROUTE_RESOURCE_TYPE, networkTier.Name),
            "Name" : formatName(AZURE_ROUTE_TABLE_ROUTE_RESOURCE_TYPE, networkTier.Id),
            "Type" : AZURE_ROUTE_TABLE_ROUTE_RESOURCE_TYPE
          }
        }
      }
    )]
  [/#list]

  [#assign componentState =
    {
      "Resources" : {
        "vnet" : {
          "Id" : vnetId,
          "Name" : vnetName,
          "Address" : networkAddress + "/" + networkMask,
          "Type" : AZURE_VIRTUAL_NETWORK_RESOURCE_TYPE
        },
        "subnets" : subnets,
        "routeTableRoutes" : routeTableRoutes
      },
      "Attributes" : {},
      "Roles" : {
        "Inbound" : {},
        "Outbound" : {}
      }
    }
  ]
[/#macro]

[#macro azure_networkroute_arm_state occurrence parent={}]
  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#--
    The routeTable known as "default" refers to the Microsoft managed routeTable.
   --]
  [#if ! (core.SubComponent.Name == "default") ]
    [#assign componentState =
      {
        "Resources" : {
          "routeTable" : {
            "Id" : formatDependentResourceId(AZURE_ROUTE_TABLE_RESOURCE_TYPE, core.Id),
            "Name" : formatName(AZURE_ROUTE_TABLE_RESOURCE_TYPE, core.ShortName),
            "Type" : AZURE_ROUTE_TABLE_RESOURCE_TYPE
          }
        },
        "Attributes" : {},
        "Roles" : {
            "Inbound" : {},
            "Outbound" : {}
        }
      }
    ]
  [#else]
    [#assign componentState =
      {
        "Resources" : {},
        "Attributes" : {},
        "Roles" : {
            "Inbound" : {},
            "Outbound" : {}
        }
      }
    ]
  [/#if]
[/#macro]

[#macro azure_networkacl_arm_state occurrence parent={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#local vnet = parent.State.Resources["vnet"]]

  [#local nsgId = formatDependentNetworkSecurityGroupId(vnet.Id, core.Id)]
  [#local nsgName = formatName(AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE, core.ShortFullName)]

  [#local resources = {}]

  [#if ! (core.SubComponent.Name == "_none") ]

    [#local resources = mergeObjects(
      resources,
      {
        "networkSecurityGroup" : {
          "Id" : nsgId,
          "Name" : nsgName,
          "Type" : AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE,
          "Reference" : getReference(nsgId, nsgName)
        }
    })]

    [#-- flow log config --]
    [#list parent.Configuration.Solution.Logging.FlowLogs as id,flowlog]
        [#local flowLogId = formatDependentNetworkWatcherId(nsgId)]

        [#local resources = mergeObjects(
            resources,
            {
              "flowLogs" : {
                id : {
                  "Id" : formatId(AZURE_NETWORK_WATCHER_FLOWLOG_RESOURCE_TYPE, vnet.Id, nsgId, id),
                  "Name" : formatName(core.Name, id, AZURE_NETWORK_WATCHER_FLOWLOG_RESOURCE_TYPE),
                  "Type" : AZURE_NETWORK_WATCHER_FLOWLOG_RESOURCE_TYPE,
                  "StorageLink" : (flowlog.s3.Link)!{}
                }
              }
            }
          )]
      [/#list]
  [/#if]

  [#assign componentState =
    {
      "Resources" : resources,
      "Attributes" : {},
      "Roles" : {
        "Inbound" : {},
        "Outbound" : {}
      }
    }
  ]
[/#macro]
