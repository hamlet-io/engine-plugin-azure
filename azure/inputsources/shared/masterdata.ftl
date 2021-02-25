[#ftl]

[#macro azure_input_shared_masterdata_seed]
  [@addMasterData
    data=
    {
        "Regions": {
            "southcentralus": {
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                "Partition": "azure",
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
                        "multiAZ": true,
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
                        "multiAZ": true,
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
                }
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
                }
            },
            "basic": {
                "db": {
                    "Processor": "B_Gen5_1"
                },
                "containerhost": {
                    "MaxCount": 2,
                    "MinCount": 0,
                    "DesiredCount": 1
                }
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
                }
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
                }
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
            "RotateKeys": true,
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
