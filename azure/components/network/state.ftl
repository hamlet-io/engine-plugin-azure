[#ftl]

[#macro azure_network_arm_state occurrence parent={}]

  [#local core = occurrence.Core]
  [#local solution = occurrence.Configuration.Solution]

  [#local vnetId = formatVirtualNetworkId(core.Id)]
  [#local vnetName = core.ShortTypedFullName]

  [#-- flow log config --]
  [#local flowLogs = {}]
  [#list solution.Logging.FlowLogs as id,flowlog]
    [#local flowLogId = formatDependentNetworkWatcherId(nsgId)]

    [#-- default storage --]
    [#local storageId = getExistingReference(formatResourceId(AZURE_STORAGEACCOUNT_RESOURCE_TYPE, core.Id))]

    [#if flowlog.Prefix??]
      [@fatal
        message="Network Watcher FlowLogs do not support a Prefix in Azure at this time."
        context=flowlog
      /]
    [/#if]

    [#if (flowlog.DestinationType!{})?has_content && (flowlog.DestinationType != "s3")]
      [@fatal
        message="Invalid flow log destination type. Only s3 is supported."
        context=flowlog
      /]
    [/#if]

    [#-- destination assignment --]
    [#if flowlog.s3??]
      [#-- link --]
      [#if isPresent(flowlog.s3.Link)]
        [#local flowLogTarget = getLinkTarget(occurrence, flowlog.s3.Link)]
        [#if flowLogTarget?has_content]
          [#local storageId = flowLogTarget]
        [/#if]
      [/#if]

      [#-- prefix --]
      [#if flowlog.s3.Prefix??]
        [#local prefix = flowlog.s3.Prefix ]
      [/#if]
    [/#if]

    [#local flowLogs += {
        id : {
          "Id" : formatId(AZURE_NETWORK_WATCHER_FLOWLOG_RESOURCE_TYPE, nsgId, id),
          "Name" : formatName(vnetName, AZURE_NETWORK_WATCHER_FLOWLOG_RESOURCE_TYPE),
          "Type" : AZURE_NETWORK_WATCHER_FLOWLOG_RESOURCE_TYPE,
          "StorageId" : storageId,
          "Prefix" : prefix
        }
    }]
  [/#list]

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
      } +
      attributeIfContent("flowlogs", flowLogs),
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
    [#local resources += {
        "networkSecurityGroup" : {
          "Id" : nsgId,
          "Name" : nsgName,
          "Type" : AZURE_VIRTUAL_NETWORK_SECURITY_GROUP_RESOURCE_TYPE,
          "Reference" : getReference(nsgId, nsgName)
        }
    }]
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
