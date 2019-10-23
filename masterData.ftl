
[#ftl]
[@addMasterData
  provider=AZURE_PROVIDER
  data=
  {
    "Regions": {
      "eastus": {
        "Partitian": "azure",
        "Locality": "UnitedStates",
        "Zones": {
          "a": {
            "Title": "Zone A",
            "Description": "Zone A",
            "AzureId" : "eastus"
          }
        },
        "Accounts": {}
      }
    },
    "Tiers": {
      "mgmt": {
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
                  "Engine": "ssh"
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
                "internal": {},
                "external": {
                  "Public": true
                }
              },
              "NetworkACLs": {
                "open": {
                  "Rules": {
                    "in": {
                      "Priority": 200,
                      "Action": "allow",
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
                      },
                      "ReturnTraffic": false
                    },
                    "out": {
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
                    "external": {
                      "Tier": "mgmt",
                      "Component": "vpc",
                      "Version": "",
                      "Instance": "",
                      "RouteTable": "external"
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
                    "internal": {
                      "Tier": "mgmt",
                      "Component": "vpc",
                      "Version": "",
                      "Instance": "",
                      "RouteTable": "internal"
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
                    "internal": {
                      "Tier": "mgmt",
                      "Component": "vpc",
                      "Version": "",
                      "Instance": "",
                      "RouteTable": "internal"
                    },
                    "external": {
                      "Tier": "mgmt",
                      "Component": "vpc",
                      "Version": "",
                      "Instance": "",
                      "RouteTable": "external"
                    }
                  }
                }
              }
            }
          }
        }
      },
      "gbl": {
        "Components": {
          "cfredirect": {
            "Lambda": {
              "Instances": {
                "default": {
                  "Versions": {
                    "v1": {
                      "DeploymentUnits": [
                        "cfredirect-v1"
                      ],
                      "Enabled": false,
                      "Fragment": "_cfredirect-v1"
                    }
                  }
                }
              },
              "DeploymentType": "EDGE",
              "RunTime": "nodejs8.10",
              "MemorySize": 128,
              "Timeout": 1,
              "FixedCodeVersion": {},
              "Functions": {
                "cfredirect": {
                  "Handler": "index.handler",
                  "VPCAccess": false,
                  "Permissions": {
                    "Decrypt": false,
                    "AsFile": false,
                    "AppData": false,
                    "AppPublic": false
                  },
                  "PredefineLogGroup": false
                }
              }
            }
          }
        }
      }
    },
    "Storage": {
      "default": {
        "storageAccount": {
          "Tier": "Standard",
          "Replication": "LRS",
          "Type": "BlobStorage",
          "AccessTier" : "Cool",
          "HnsEnabled" : false
        }
      },
      "Blob": {
        "storageAccount" : {
          "Tier" : "Standard",
          "Replication" : "LRS",
          "Type" : "BlobStorage",
          "AccessTier" : "Cool",
          "HnsEnabled" : false
        }
      },
      "File": {
        "storageAccount" : {
          "Tier" : "Standard",
          "Replication" : "LRS",
          "Type" : "FileStorage",
          "HnsEnabled" : false
        }
      },
      "Block": {
        "storageAccount" : {
          "Tier" : "Standard",
          "Replication" : "LRS",
          "Type" : "BlockBlobStorage",
          "HnsEnabled" : false
        }
      }
    },
    "Processors": {
      "default": {}
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
    "SecurityProfiles": {
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
    "NetworkEndpointGroups": {},
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
          "gbl"
        ]
      }
    }
  }
/]
  