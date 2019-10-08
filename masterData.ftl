
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
            "Description": "Zone A"
          }
        },
        "Accounts": {}
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
    "ResourceProfiles": {
      "azure" : {
        "microsoft.network" : { 
          "applicationSecurityGroups" : {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Network/applicationSecurityGroups"
          },
          "routeTables" : {
            "apiVersion" : "2019-02-01",
            "type" : "Microsoft.Network/routeTables"
          },
          "routes" : {
            "apiVersion" : "2019-02-01",
            "type" : "Microsoft.Network/routeTables/routes"
          },
          "serviceEndpointPolicies" : {
            "apiVersion" : "2019-02-01",
            "type" : "Microsoft.Network/serviceEndpointPolicies"
          },
          "serviceEndpointPolicyDefinitions" : {
            "apiVersion" : "2019-02-01",
            "type" : "Microsoft.Network/serviceEndpointPolicies/serviceEndpointPolicyDefinitions"
          },
          "subnets" : {
            "apiVersion" : "2019-02-01",
            "type" : "Microsoft.Network/virtualNetworks/subnets"
          },
          "virtualNetworks" : {
            "apiVersion" : "2019-02-01",
            "type" : "Microsoft.Network/virtualNetworks"
          },
          "virtualNetworkPeerings" : {
            "apiVersion" : "2019-02-01",
            "type" : "Microsoft.Network/virtualNetworks/virtualNetworkPeerings"
          },
          "networkSecurityGroups" : {
            "apiVersion" : "2019-02-01",
            "type" : "Microsoft.Network/networkSecurityGroups"
          },
          "securityRules" : {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Network/networkSecurityGroups/securityRules"
          },
          "networkWatchers" : {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Network/networkWatchers"
          }
        },
        "microsoft.storage" : {
          "account" : {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Storage/storageAccounts"
          },
          "blob" : {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Storage/storageAccounts/blobServices"
          },
          "container" : {
            "apiVersion" : "2019-04-01",
            "type" : "Microsoft.Storage/storageAccounts/blobServices/containers"
          }
        }
      }
    }
    "ScriptStores": {},
    "Bootstraps": {},
    "BootstrapProfiles": {
      "default": {}
    },
    "SecurityProfiles": {
      "default": {}
    },
    "BaselineProfiles": {
      "default": {}
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
  