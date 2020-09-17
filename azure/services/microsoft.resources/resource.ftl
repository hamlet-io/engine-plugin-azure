[#ftl]

[@addResourceProfile
  service=AZURE_RESOURCES_SERVICE
  resource=AZURE_DEPLOYMENT_RESOURCE_TYPE
  profile=
    {
      "apiVersion" : "2019-10-01",
      "type" : "Microsoft.Resources/deployments",
      "conditions" : [ "alphanumerichyphens_only" ],
      "outputMappings" : {}
    }
/]