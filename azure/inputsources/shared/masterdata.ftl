[#ftl]

[#macro azure_input_shared_masterdata_seed]
  [@addMasterData
    data=
    {
        "Regions": {
            "southcentralus": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "southcentralus",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "brazilsouth": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "brazilsouth",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "eastus": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "eastus",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "eastus2": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "eastus2",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "northcentralus": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "northcentralus",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "northeurope": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "northeurope",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "westeurope": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "westeurope",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "westus": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "westus",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "eastasia": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "eastasia",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "southeastasia": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "southeastasia",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "global": {
                "Partitian": "azure",
                "Locality": "none",
                "Zones": {
                    "a": {
                        "Title": "Global",
                        "Description": "A Global Zone",
                        "AWSZone": "global",
                        "NetworkEndpoints": []
                    }
                },
                "Accounts": {}
            },
            "centralus": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "centralus",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "japanwest": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "japanwest",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "japaneast": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "japaneast",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "australiaeast": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "australiaeast",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "australiasoutheast": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "australiasoutheast",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "southindia": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "southindia",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "centralindia": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "centralindia",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "westindia": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "westindia",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "canadaeast": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "canadaeast",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "canadacentral": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "canadacentral",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "uksouth": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "uksouth",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "ukwest": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "ukwest",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "westcentralus": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "westcentralus",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "westus2": {
                "Partitian": "azure",
                "Locality": "Americas",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "westus2",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "koreacentral": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "koreacentral",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "koreasouth": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "koreasouth",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "francecentral": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "francecentral",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "francesouth": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "francesouth",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "australiacentral": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "australiacentral",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "australiacentral2": {
                "Partitian": "azure",
                "Locality": "Asia Pacific",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "australiacentral2",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "uaecentral": {
                "Partitian": "azure",
                "Locality": "Middle East and Africa",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "uaecentral",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "uaenorth": {
                "Partitian": "azure",
                "Locality": "Middle East and Africa",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "uaenorth",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "southafricanorth": {
                "Partitian": "azure",
                "Locality": "Middle East and Africa",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "southafricanorth",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "southafricawest": {
                "Partitian": "azure",
                "Locality": "Middle East and Africa",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "southafricawest",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "switzerlandnorth": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "switzerlandnorth",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "switzerlandwest": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "switzerlandwest",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "germanynorth": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "germanynorth",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "germanywestcentral": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "germanywestcentral",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "norwaywest": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "norwaywest",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            },
            "norwayeast": {
                "Partitian": "azure",
                "Locality": "Europe",
                "Zones": {
                    "a": {
                        "Title": "Zone A",
                        "Description": "Zone A",
                        "AWSZone": "norwayeast",
                        "NetworkEndpoints": [
                            {
                                "Type": "Interface",
                                "ServiceName": "Microsoft.Storage"
                            }
                        ]
                    }
                },
                "Accounts": {}
            }
        },
        "Tiers": {
            "api": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Private"
                }
            },
            "ana": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Private"
                }
            },
            "app": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Private"
                }
            },
            "db": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Private"
                }
            },
            "dir": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Private"
                }
            },
            "docs": {},
            "elb": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Public"
                }
            },
            "gbl": {
                "Components": {}
            },
            "ilb": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Private"
                }
            },
            "mgmt": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Public"
                },
                "Components": {
                    "baseline": {
                        "DeploymentUnits": [
                            "baseline"
                        ],
                        "baseline": {
                            "DataBuckets": {
                                "opsdata": {
                                    "Role": "operations",
                                    "Lifecycles": {
                                        "awslogs": {
                                            "Prefix": "AWSLogs",
                                            "Expiration": "_operations",
                                            "Offline": "_operations"
                                        },
                                        "cloudfront": {
                                            "Prefix": "CLOUDFRONTLogs",
                                            "Expiration": "_operations",
                                            "Offline": "_operations"
                                        },
                                        "docker": {
                                            "Prefix": "DOCKERLogs",
                                            "Expiration": "_operations",
                                            "Offline": "_operations"
                                        }
                                    },
                                    "Links": {
                                        "cf_key": {
                                            "Tier": "mgmt",
                                            "Component": "baseline",
                                            "Instance": "",
                                            "Version": "",
                                            "Key": "oai"
                                        }
                                    }
                                },
                                "appdata": {
                                    "Role": "appdata",
                                    "Lifecycles": {
                                        "global": {
                                            "Expiration": "_data",
                                            "Offline": "_data"
                                        }
                                    }
                                },
                                "web": {
                                    "Role": "staticWebsite"
                                }
                            },
                            "Keys": {
                                "ssh": {
                                    "Engine": "ssh",
                                    "IPAddressGroups": [
                                        "_global"
                                    ]
                                },
                                "cmk": {
                                    "Engine": "cmk"
                                },
                                "oai": {
                                    "Engine": "oai"
                                }
                            }
                        }
                    },
                    "ssh": {
                        "DeploymentUnits": [
                            "ssh"
                        ],
                        "MultiAZ": true,
                        "bastion": {
                            "AutoScaling": {
                                "DetailedMetrics": false,
                                "ActivityCooldown": 180,
                                "MinUpdateInstances": 0,
                                "AlwaysReplaceOnUpdate": false
                            }
                        }
                    },
                    "vpc": {
                        "DeploymentUnits": [
                            "vpc"
                        ],
                        "MultiAZ": true,
                        "network": {
                            "RouteTables": {
                                "default": {}
                            },
                            "NetworkACLs": {
                                "Public": {
                                    "Rules": {
                                        "internetAccess": {
                                            "Priority": 200,
                                            "Action": "allow",
                                            "Source": {
                                                "IPAddressGroups": [
                                                    "_localnet"
                                                ]
                                            },
                                            "Destination": {
                                                "IPAddressGroups": [
                                                    "_global"
                                                ],
                                                "Port": "any"
                                            },
                                            "ReturnTraffic": false
                                        }
                                    }
                                },
                                "Private": {
                                    "Rules": {
                                        "internetAccess": {
                                            "Priority": 200,
                                            "Action": "allow",
                                            "Source": {
                                                "IPAddressGroups": [
                                                    "_localnet"
                                                ]
                                            },
                                            "Destination": {
                                                "IPAddressGroups": [
                                                    "_global"
                                                ],
                                                "Port": "any"
                                            }
                                        },
                                        "blockInbound": {
                                            "Priority": 100,
                                            "Action": "deny",
                                            "Source": {
                                                "IPAddressGroups": [
                                                    "_global"
                                                ]
                                            },
                                            "Destination": {
                                                "IPAddressGroups": [
                                                    "_localnet"
                                                ],
                                                "Port": "any"
                                            }
                                        }
                                    }
                                }
                            },
                            "Links": {
                                "NetworkEndpoints": {
                                    "Tier": "mgmt",
                                    "Component": "vpcendpoint",
                                    "Version": "",
                                    "Instance": ""
                                }
                            }
                        }
                    },
                    "vpcendpoint": {
                        "DeploymentUnits": [
                            "vpcendpoint"
                        ],
                        "gateway": {
                            "Engine": "privateservice",
                            "Destinations": {
                                "default": {
                                    "NetworkEndpointGroups": [
                                        "storage",
                                        "logs"
                                    ],
                                    "Links": {
                                        "Private": {
                                            "Tier": "mgmt",
                                            "Component": "vpc",
                                            "Version": "",
                                            "Instance": "",
                                            "RouteTable": "default"
                                        },
                                        "Public": {
                                            "Tier": "mgmt",
                                            "Component": "vpc",
                                            "Version": "",
                                            "Instance": "",
                                            "RouteTable": "default"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            "msg": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Private"
                }
            },
            "shared": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Public"
                }
            },
            "web": {
                "Network": {
                    "RouteTable": "default",
                    "NetworkACL": "Private"
                }
            }
        },
        "Ports": {
            "gatewaymanager": {
                "PortRange": {
                    "From": 65200,
                    "To": 65535
                },
                "IPProtocol": "all"
            }
        },
        "Storage": {
            "default": {
                "storageAccount": {
                    "Tier": "Standard",
                    "Replication": "LRS",
                    "Type": "StorageV2",
                    "AccessTier": "Cool",
                    "HnsEnabled": false
                },
                "computecluster": {
                    "Tier": "Standard",
                    "Replication": "LRS"
                },
                "containerhost": {},
                "containerservice": {},
                "containertask": {}
            },
            "Blob": {
                "storageAccount": {
                    "Tier": "Standard",
                    "Replication": "LRS",
                    "Type": "BlobStorage",
                    "AccessTier": "Cool",
                    "HnsEnabled": false
                }
            },
            "File": {
                "storageAccount": {
                    "Tier": "Standard",
                    "Replication": "LRS",
                    "Type": "FileStorage",
                    "HnsEnabled": false
                }
            },
            "Block": {
                "storageAccount": {
                    "Tier": "Standard",
                    "Replication": "LRS",
                    "Type": "BlockBlobStorage",
                    "HnsEnabled": false
                }
            }
        },
        "Processors": {
            "default": {
                "bastion": {
                    "Processor": "Standard_B1s"
                },
                "db": {
                    "Processor": "GP_Gen5_2"
                },
                "containerhost": {
                    "MaxCount": 2,
                    "MinCount": 1,
                    "DesiredCount": 1
                },
                "containerservice": {},
                "containertask": {}
            },
            "basic": {
                "db": {
                    "Processor": "B_Gen5_1"
                },
                "containerhost": {
                    "MaxCount": 2,
                    "MinCount": 0,
                    "DesiredCount": 1
                },
                "containerservice": {},
                "containertask": {}
            }
        },
        "CertificateBehaviours": {
            "External": false,
            "Wildcard": true,
            "IncludeInHost": {
                "Product": false,
                "Segment": false,
                "Tier": false
            },
            "HostParts": [
                "Host",
                "Tier",
                "Component",
                "Instance",
                "Version",
                "Segment",
                "Environment",
                "Product"
            ],
            "Qualifiers": {
                "prod": {
                    "IncludeInHost": {
                        "Environment": false
                    },
                    "IncludeInDomain": {
                        "Environment": false
                    }
                }
            }
        },
        "LogFiles": {},
        "LogFileGroups": {},
        "LogFileProfiles": {
            "default": {}
        },
        "CORSProfiles": {
            "S3Write": {
                "AllowedHeaders": [
                    "Content-Length",
                    "Content-Type",
                    "Content-MD5",
                    "Authorization",
                    "Expect",
                    "x-amz-content-sha256",
                    "x-amz-security-token"
                ]
            },
            "S3Delete": {
                "AllowedHeaders": [
                    "Content-Length",
                    "Content-Type",
                    "Content-MD5",
                    "Authorization",
                    "Expect",
                    "x-amz-content-sha256",
                    "x-amz-security-token"
                ]
            }
        },
        "ScriptStores": {},
        "Bootstraps": {
            "update-debian": {
                "Index": 10,
                "ProtectedSettings": {
                    "exec": {
                        "Key": "commandToExecute",
                        "Value": "sudo apt update'"
                    }
                }
            },
            "azcli-debian": {
                "Index": 15,
                "ProtectedSettings": {
                    "exec": {
                        "Key": "commandToExecute",
                        "Value": "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash'"
                    }
                }
            },
            "docker-debian": {
                "Index": 16,
                "ProtectedSettings": {
                    "exec": {
                        "Key": "commandToExecute",
                        "Value": "sudo apt install docker.io -y'"
                    }
                }
            },
            "stage": {
                "Index": 25,
                "AutoUpgradeOnMinorVersion": true,
                "ProtectedSettings": {
                    "exec": {
                        "Key": "commandToExecute",
                        "Value": "az storage blob download --connection-string ', parameters('storage'), ' -c ', parameters('container'), ' -n ', parameters('blob'), ' -f ', parameters('file')"
                    },
                    "systemAssignedIdentity": {
                        "Key": "managedIdentity",
                        "Value": {}
                    }
                }
            },
            "unzip": {
                "Index": 30,
                "ProtectedSettings": {
                    "exec": {
                        "Key": "commandToExecute",
                        "Value": "sudo apt install unzip && unzip -DD ', parameters('file'), ' -d .'"
                    }
                }
            },
            "init": {
                "Index": 100,
                "Publisher": "Microsoft.Azure.Extensions",
                "Type": {
                    "Name": "CustomScript",
                    "HandlerVersion": "2.1"
                },
                "ProtectedSettings": {
                    "initEncoded": {
                        "Key": "commandToExecute",
                        "Value": "chmod 755 ./init.sh && ./init.sh"
                    }
                }
            },
            "timestamp": {
                "Index": 1000,
                "Settings": {
                    "addTimestamp": {
                        "Key": "timestamp",
                        "Value": "[parameters('timestamp')]"
                    }
                }
            }
        },
        "BootstrapProfiles": {
            "default": {
                "computecluster": {
                    "Bootstraps": [
                        "update-debian",
                        "azcli-debian",
                        "docker-debian",
                        "stage",
                        "unzip",
                        "init",
                        "timestamp"
                    ]
                }
            }
        },
        "BaselineProfiles": {
            "default": {
                "OpsData": "opsdata",
                "AppData": "appdata",
                "Encryption": "cmk",
                "SSHKey": "ssh",
                "CDNOriginKey": "oai"
            }
        },
        "LogFilters": {},
        "VMImageProfiles": {
            "default": {
                "bastion": {
                    "Publisher": "Canonical",
                    "Offering": "UbuntuServer",
                    "Image": "18.04-LTS"
                },
                "computecluster": {
                    "Publisher": "Canonical",
                    "Offering": "UbuntuServer",
                    "Image": "18.04-LTS"
                },
                "containerhost": {
                  "Offering" : "linux"
                },
                "containerservice": {},
                "containertask": {}
            }
        },
        "NetworkEndpointGroups": {
            "compute": {
                "Services": []
            },
            "security": {
                "Services": []
            },
            "configurationMgmt": {
                "Services": []
            },
            "containers": {
                "Services": []
            },
            "serverless": {
                "Services": []
            },
            "logs": {
                "Services": []
            },
            "storage": {
                "Services": [
                    "Microsoft.Storage"
                ]
            }
        },
        "PlacementProfiles": {
            "default": {
                "default": {
                    "Provider": "azure",
                    "Region": "australiaeast",
                    "DeploymentFramework": "arm"
                }
            }
        },
        "DeploymentProfiles": {
            "default": {
                "Modes": {
                    "*": {}
                }
            }
        },
        "SkuProfiles": {
            "default": {
                "apigateway": {
                    "Name": "Developer"
                },
                "bastion": {
                    "Name": "Standard_B1ms",
                    "Tier": "Standard",
                    "Capacity": 0
                },
                "computecluster": {
                    "Name": "Standard_B1ms",
                    "Tier": "Standard",
                    "Capacity": 1
                },
                "containerhost": {
                    "Name": "P1v2",
                    "Tier": "PremiumV2",
                    "Capacity": 1,
                    "Size": "P1v2",
                    "Family": "Pv2"
                },
                "containerservice": {},
                "containertask": {}
            }
        },
        "Segment": {
            "Network": {
                "InternetAccess": true,
                "Tiers": {
                    "Order": [
                        "web",
                        "msg",
                        "app",
                        "db",
                        "dir",
                        "ana",
                        "api",
                        "spare",
                        "elb",
                        "ilb",
                        "spare",
                        "spare",
                        "spare",
                        "spare",
                        "spare",
                        "mgmt"
                    ]
                },
                "Zones": {
                    "Order": [
                        "a",
                        "b",
                        "spare",
                        "spare"
                    ]
                }
            },
            "NAT": {
                "Enabled": true,
                "MultiAZ": false,
                "Hosted": true
            },
            "Bastion": {
                "Enabled": true,
                "Active": false,
                "IPAddressGroups": []
            },
            "S3": {
                "IncludeTenant": false
            },
            "RotateKey": true,
            "Tiers": {
                "Order": [
                    "elb",
                    "api",
                    "web",
                    "msg",
                    "dir",
                    "ilb",
                    "app",
                    "db",
                    "ana",
                    "mgmt",
                    "docs",
                    "gbl",
                    "external"
                ]
            }
        }
    }
  /]
[/#macro]
