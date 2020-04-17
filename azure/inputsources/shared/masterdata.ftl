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
              "AzureId": "southcentralus",
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
              "AzureId": "brazilsouth",
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
              "AzureId": "eastus",
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
              "AzureId": "eastus2",
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
              "AzureId": "northcentralus",
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
              "AzureId": "northeurope",
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
              "AzureId": "westeurope",
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
              "AzureId": "westus",
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
              "AzureId": "eastasia",
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
              "AzureId": "southeastasia",
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
              "AzureId": "global",
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
              "AzureId": "centralus",
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
              "AzureId": "japanwest",
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
              "AzureId": "japaneast",
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
              "AzureId": "australiaeast",
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
              "AzureId": "australiasoutheast",
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
              "AzureId": "southindia",
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
              "AzureId": "centralindia",
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
              "AzureId": "westindia",
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
              "AzureId": "canadaeast",
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
              "AzureId": "canadacentral",
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
              "AzureId": "uksouth",
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
              "AzureId": "ukwest",
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
              "AzureId": "westcentralus",
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
              "AzureId": "westus2",
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
              "AzureId": "koreacentral",
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
              "AzureId": "koreasouth",
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
              "AzureId": "francecentral",
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
              "AzureId": "francesouth",
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
              "AzureId": "australiacentral",
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
              "AzureId": "australiacentral2",
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
              "AzureId": "uaecentral",
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
              "AzureId": "uaenorth",
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
              "AzureId": "southafricanorth",
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
              "AzureId": "southafricawest",
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
              "AzureId": "switzerlandnorth",
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
              "AzureId": "switzerlandwest",
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
              "AzureId": "germanynorth",
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
              "AzureId": "germanywestcentral",
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
              "AzureId": "norwaywest",
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
              "AzureId": "norwayeast",
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
          "Components": {
          }
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
            "seg-cert": {
              "DeploymentUnits": [
                "cert"
              ]
            },
            "seg-dns": {
              "DeploymentUnits": [
                "dns"
              ],
              "Enabled": false
            },
            "seg-dashboard": {
              "DeploymentUnits": [
                "dashboard"
              ],
              "Enabled": false
            },
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
                  "default" : {}
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
                    "Instance": "",
                    "Destination" : "default"
                  }
                }
              }
            },
            "igw": {
              "DeploymentUnits": [
                "igw"
              ],
              "gateway": {
                "Engine": "igw",
                "Destinations": {
                  "default": {
                    "IPAddressGroups": "_global",
                    "Links": {
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
            },
            "nat": {
              "DeploymentUnits": [
                "nat"
              ],
              "gateway": {
                "Engine": "natgw",
                "Destinations": {
                  "default": {
                    "IPAddressGroups": "_global",
                    "Links": {
                      "Private": {
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
            },
            "vpcendpoint": {
              "DeploymentUnits": [
                "vpcendpoint"
              ],
              "gateway": {
                "Engine": "vpcendpoint",
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
      "Ports" : {
        "gatewaymanager": {
          "PortRange" : {
            "From" : 65200,
            "To" : 65535
          },
          "IPProtocol" : "all"
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
      "Bootstraps": {},
      "BootstrapProfiles": {
        "default": {}
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
      "VMImageProfiles" : {
        "bastion" : {
          "Publisher" : "Canonical",
          "Offering" : "UbuntuServer",
          "SKU" : "18.04-LTS"
        }
      },
      "NetworkEndpointGroups": {
        "compute" : {
          "Services" : []
        },
        "security" : {
          "Services" : []
        },
        "configurationMgmt" : {
          "Services" : []
        },
        "containers" : {
          "Services" : []
        },
        "serverless" : {
          "Services" : []
        },
        "logs" : {
          "Services" : []
        },
        "storage" : {
          "Services" : [
            "Microsoft.Storage"
          ]
        }
      },
      "DeploymentProfiles": {
        "default": {
          "Modes": {
            "*": {}
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
        "ConsoleOnly": false,
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