# Changelog

## latest (2023-06-01)

#### Fixes

* syntax error
* (ci): update to latest shared workflows ([#313](https://github.com/hamlet-io/engine-plugin-azure/issues/313))
* (computecluster): bootstraps lookup from global
* remove use of getRegistryPrefix and EndPoint ([#310](https://github.com/hamlet-io/engine-plugin-azure/issues/310))
#### Refactorings

* replace reference lookups with function
* standardise github workflows ([#309](https://github.com/hamlet-io/engine-plugin-azure/issues/309))
#### Others

* update changelog ([#308](https://github.com/hamlet-io/engine-plugin-azure/issues/308))

Full set of changes: [`8.8.0...latest`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.8.0...latest)

## 8.8.0 (2022-10-13)

#### New Features

* (network): manage vpn cipher configuration
#### Refactorings

* use base level attribute sets ([#307](https://github.com/hamlet-io/engine-plugin-azure/issues/307))
#### Others

* update changelog ([#305](https://github.com/hamlet-io/engine-plugin-azure/issues/305))

Full set of changes: [`8.7.0...8.8.0`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.7.0...8.8.0)

## 8.7.0 (2022-08-23)

#### Fixes

* (lb): standard error for invalid port mapping
#### Others

* update changelog ([#303](https://github.com/hamlet-io/engine-plugin-azure/issues/303))

Full set of changes: [`8.6.2...8.7.0`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.6.2...8.7.0)

## 8.6.2 (2022-06-07)

#### Fixes

* (network): usestorage account instead of container in logs
* (network): flow log configuration
* (apigateway): handle different registry types
#### Refactorings

* remove mock output service from testing
* use shared changelog action ([#301](https://github.com/hamlet-io/engine-plugin-azure/issues/301))
* enabled handling for suboccurrences
#### Others

* update changelog ([#298](https://github.com/hamlet-io/engine-plugin-azure/issues/298))
* changelog bump
* changelog bump

Full set of changes: [`8.6.0...8.6.2`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.6.0...8.6.2)

## 8.6.0 (2022-04-15)

#### Refactorings

* move test module loading to product layer

Full set of changes: [`8.5.0...8.6.0`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.5.0...8.6.0)

## 8.5.0 (2022-03-25)

#### Fixes

* (lambda): align runtimes with latest updates
#### Refactorings

* use local engine for testing ([#294](https://github.com/hamlet-io/engine-plugin-azure/issues/294))
#### Others

* changelog bump ([#292](https://github.com/hamlet-io/engine-plugin-azure/issues/292))

Full set of changes: [`8.4.0...8.5.0`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.4.0...8.5.0)

## 8.4.0 (2022-01-06)

#### New Features

* (directory): Azure AD Directory Services
* (gateway): support for inside tunnel config
* support emtpy destination for any
* site to site VPN support
* core azure provider updates
#### Fixes

* update database credentials setup
* (lambda): build settings lookup
* (baseline): keystore cleanup
* flow log setup
* remove extra container creation
* remove jq
#### Refactorings

* bastion network access
* (computecluster): nsg updates
* (network): refactor network setup process
* remove azure utilities
* setContext wrapper functions (1) ([#278](https://github.com/hamlet-io/engine-plugin-azure/issues/278))
* remove dos2unix usage
#### Others

* changelog bump ([#277](https://github.com/hamlet-io/engine-plugin-azure/issues/277))
* changelog bump ([#273](https://github.com/hamlet-io/engine-plugin-azure/issues/273))

Full set of changes: [`8.3.0...8.4.0`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.3.0...8.4.0)

## 8.3.0 (2021-08-15)

#### Refactorings

* lb fqdn handling

Full set of changes: [`8.2.1...8.3.0`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.2.1...8.3.0)

## 8.2.1 (2021-07-09)

#### Fixes

* (ci): tag build handling ([#274](https://github.com/hamlet-io/engine-plugin-azure/issues/274))
#### Others

* changelog bump ([#269](https://github.com/hamlet-io/engine-plugin-azure/issues/269))

Full set of changes: [`8.2.0...8.2.1`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.2.0...8.2.1)

## 8.2.0 (2021-07-01)

#### New Features

* run docker build on pr
* ci migration for github actions
* support for docker based packaging
#### Fixes

* tagging defaults
* if condition
* (ci): update package trigger pr syntax
* include guaranteed tag
* changelog generation
* (ci): add pr trigger to testing
* handle missing values for bootstraps
* profile lookup updates and extensions
#### Refactorings

* (ci): quality of life updates
* (ci): remove git dir from docker
* remove direct references to region
* (ci): updates from testing and ops
* align profile usage with shared provider
* remove use of segmentQualifier ([#260](https://github.com/hamlet-io/engine-plugin-azure/issues/260))
#### Docs

* replace changelog and update README

Full set of changes: [`8.1.2...8.2.0`](https://github.com/hamlet-io/engine-plugin-azure/compare/8.1.2...8.2.0)

## 8.1.2 (2021-05-17)

#### New Features

* (apigateway): openapi specification extension
* add storage profile configuration for spa
* (apigateway): adds image source support ([#251](https://github.com/hamlet-io/engine-plugin-azure/issues/251))
* add corsbehaviours on SPA component for Az
* (cd): setup latest hamlet on each run
* add azure diagrams
* add readme to repository
* new ARM resource - KeyVault Keys
* input seeders ([#224](https://github.com/hamlet-io/engine-plugin-azure/issues/224))
* (ci): Align azure testing with plugins and include junit ([#221](https://github.com/hamlet-io/engine-plugin-azure/issues/221))
* (db): mysql as a engine type 
* changelog generation ([#219](https://github.com/hamlet-io/engine-plugin-azure/issues/219))
* migrate from fragments to extensions ([#212](https://github.com/hamlet-io/engine-plugin-azure/issues/212))
* introduce function to break down id path segments into scope
* microsoft.resources service to be available to all components
* (resources): incorporate scope into azureResourceProfiles ([#198](https://github.com/hamlet-io/engine-plugin-azure/issues/198))
* (baseline): allow multiple keyVaultAdmins ([#178](https://github.com/hamlet-io/engine-plugin-azure/issues/178))
* :sparkles: linked db's to inject attributes as env variables
* :sparkles: db secrets assignable in solution
* Component - computecluster ([#132](https://github.com/hamlet-io/engine-plugin-azure/issues/132))
#### Fixes

* dynamic cmdb loading
* frontdoor WAF policies must be named alphanumerically
* pseudo stacks ([#247](https://github.com/hamlet-io/engine-plugin-azure/issues/247))
* invoke correct name for config pipeline function
* url details in changelog
* remove redundant clo seeding
* simplified parameters
* test args for hamlet cmd ([#235](https://github.com/hamlet-io/engine-plugin-azure/issues/235))
* debug log output on util commands ([#234](https://github.com/hamlet-io/engine-plugin-azure/issues/234))
* Azure ResourceGroup Outputs ([#229](https://github.com/hamlet-io/engine-plugin-azure/issues/229))
* invalid masterdata data ([#228](https://github.com/hamlet-io/engine-plugin-azure/issues/228))
* (cicd): jenkins pipeline structure ([#225](https://github.com/hamlet-io/engine-plugin-azure/issues/225))
* move mock input types into azure provider
* Invalid Module and Masterdata structures ([#223](https://github.com/hamlet-io/engine-plugin-azure/issues/223))
* changelog generation
* (ci): re-enable test suite
* (tests): standardise mock values
* (spa): invoke extensions on current occurrence
* (referencedata): load sku profile data inside getter func
* (referencedata): load vm image profiles inside getter func
* (tests): bring bastion name conventions into alignment with tests
* (tests): mocked output ids should be in template scope
* (outputs): expect refrenced resource in outputs
* remove call to unassigned variable
* (baseline): segment seed either does/doesn't exist
* (ci): disable test suite
* (outputs): fix retrieval of pseudo resource outputs ([#214](https://github.com/hamlet-io/engine-plugin-azure/issues/214))
* align scenario changes
* added a 60 minute timeout to build ([#203](https://github.com/hamlet-io/engine-plugin-azure/issues/203))
* validate resourcepath
* output constructions to fail elegantly
* add resource scope to scope obj
* sub/rg scoped outputs to correctly point to deployment resource outputs
* rg and sub ids are set if a parentId is provided
* remove unused parentnames parameter
* (storage): fix storage account naming ([#190](https://github.com/hamlet-io/engine-plugin-azure/issues/190))
* use regionid global var instead of command line input ([#189](https://github.com/hamlet-io/engine-plugin-azure/issues/189))
* (apigateway): fix subset scopes for apigateway generation ([#187](https://github.com/hamlet-io/engine-plugin-azure/issues/187))
* (apigateway): only check for definition file once it has been retrieved ([#186](https://github.com/hamlet-io/engine-plugin-azure/issues/186))
* (lambda): enforce global-uniqueness of name + max char limit ([#184](https://github.com/hamlet-io/engine-plugin-azure/issues/184))
* (db): allow vnet rule creation w/o service endpoint
* (cdn): ensure frontdoor names are unique globally ([#180](https://github.com/hamlet-io/engine-plugin-azure/issues/180))
* :bug: forwarding path not to start with /
* :bug: combine "script" and "commandToExecute" settings into "commandToExecute"
* :bug: timestamp now passed to settings as int
* :fire: removed erroneous bracket
* computecluster stage storage lookup values
* connectionString ARM function
* CDN Endpoint(s) 
#### Refactorings

* update output properties with new config
* (cdn): handle updated spa storage accounts
* add a default $web container to bline
* simplify baselinedata endpoint attributes
* format a service endpoint address
* incl capability to disable HealthProbeSettings
* SPA to have independant storage account
* define new storage account and blob service for each spa
* use input pipeline for all seeding
* state processing
* add service and resource mappings
* output hanlding in engine ([#239](https://github.com/hamlet-io/engine-plugin-azure/issues/239))
* CLO accessor names
* command line and masterdata references
* org wide issue templates ([#230](https://github.com/hamlet-io/engine-plugin-azure/issues/230))
* disable purge protection on keyvault
* replace CMK with new ARM resource
* composite object data types not type
* move secret attribute to shared ([#211](https://github.com/hamlet-io/engine-plugin-azure/issues/211))
* scenario module rename ([#207](https://github.com/hamlet-io/engine-plugin-azure/issues/207))
* align with layerdata configuration
* align scenarios with new loader
* switch COT to Hamlet ([#205](https://github.com/hamlet-io/engine-plugin-azure/issues/205))
* replace model flows with flows
* setup macro support for entrances
* keyvaultsecret creation macro
* rename getAzureResourceNameSegments to be more generic and reusable
* use management contract for testing ([#199](https://github.com/hamlet-io/engine-plugin-azure/issues/199))
* (deployments): tidy up unused deployment resource macros ([#197](https://github.com/hamlet-io/engine-plugin-azure/issues/197))
* remove console only from bastion masterdata ([#175](https://github.com/hamlet-io/engine-plugin-azure/issues/175))
* (gateway): rename vpcendpoint to privateservice ([#166](https://github.com/hamlet-io/engine-plugin-azure/issues/166))
* :recycle: remove unnecessary attribute
* bootstraps for dependencies
* s3 attributes
#### Others

* changelog 8.1.2 ([#258](https://github.com/hamlet-io/engine-plugin-azure/issues/258))
* (deps): bump lodash from 4.17.20 to 4.17.21 ([#257](https://github.com/hamlet-io/engine-plugin-azure/issues/257))
* (deps): bump hosted-git-info from 2.8.8 to 2.8.9
* (deps): bump handlebars from 4.7.6 to 4.7.7
* tidy up unused SPA component logic
* 8.0.1 release notes
* realign attribute parameter case ([#227](https://github.com/hamlet-io/engine-plugin-azure/issues/227))
* changelog
* changelog
