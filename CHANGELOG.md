# [0.0.0](https://github.com/hamlet-io/engine-plugin-azure/compare/8.1.2...0.0.0) (2021-05-13)



## [8.1.2](https://github.com/hamlet-io/engine-plugin-azure/compare/v8.0.1...8.1.2) (2021-05-12)


### Bug Fixes

* dynamic cmdb loading ([87f88b7](https://github.com/hamlet-io/engine-plugin-azure/commit/87f88b700ee90a70f9930ce5845000428903e103))
* frontdoor WAF policies must be named alphanumerically ([81ca445](https://github.com/hamlet-io/engine-plugin-azure/commit/81ca445c922ddb15006a0e822f85d91da0851155))
* invoke correct name for config pipeline function ([751a62f](https://github.com/hamlet-io/engine-plugin-azure/commit/751a62f5b09855e9426c920639e5f38a50d6df11))
* pseudo stacks ([#247](https://github.com/hamlet-io/engine-plugin-azure/issues/247)) ([7575b82](https://github.com/hamlet-io/engine-plugin-azure/commit/7575b82991948f2dbd0dd1d77e88170698d2f249))
* remove redundant clo seeding ([ee51874](https://github.com/hamlet-io/engine-plugin-azure/commit/ee518748ebc80696012656c08c518fd1048460ed))
* simplified parameters ([9cdb6e3](https://github.com/hamlet-io/engine-plugin-azure/commit/9cdb6e3a39fba8a0da2d216d3d7b1f1484f7084e))
* url details in changelog ([9bbc435](https://github.com/hamlet-io/engine-plugin-azure/commit/9bbc435753c3f0372811b86cd2adc348e176d86b))


### Features

* **apigateway:** openapi specification extension ([35ad83b](https://github.com/hamlet-io/engine-plugin-azure/commit/35ad83b09e0e2ded0a75700fd2c85139c836e810))
* add storage profile configuration for spa ([a032a35](https://github.com/hamlet-io/engine-plugin-azure/commit/a032a35054773b921c0c7f258abbe1cbf5fb174c))
* **apigateway:** adds image source support ([#251](https://github.com/hamlet-io/engine-plugin-azure/issues/251)) ([5e2a413](https://github.com/hamlet-io/engine-plugin-azure/commit/5e2a413bb5dc848f51032dfa3f36af64f2073c3c))
* add corsbehaviours on SPA component for Az ([eb05c7f](https://github.com/hamlet-io/engine-plugin-azure/commit/eb05c7f809b12ec9c7c166fad12253b0bc319339))
* **cd:** setup latest hamlet on each run ([2fd6ec7](https://github.com/hamlet-io/engine-plugin-azure/commit/2fd6ec7d50e3ec37fe0fd1b14cfa1da36a698879))
* add azure diagrams ([75fa143](https://github.com/hamlet-io/engine-plugin-azure/commit/75fa1438424f94656fa9b8000ef713bfdaca63d5))


* refactor!: SPA to have independant storage account ([b65daa3](https://github.com/hamlet-io/engine-plugin-azure/commit/b65daa34f1940526b8abec3b5bb647abd8ebfd29))


### BREAKING CHANGES

* As per #246, only 1 SPA per Solution is currently possible in the
Azure provider. This is due to the SPA initially deploying content
into the OpsData databucket. However Azure has some unique req. for
hosting static website content, such as a specific container name of
$web being necessary. As there can only be one container with such a
name per Storage Account, this is a problem.

This refactor implements a unique storage account per SPA deployment-
unit.

Additionally, this removes a previous limitation of SPA's that there
must be at least one existing CDN Route in order to deploy. Such a
requirement posed a chicken-and-egg problem where the CDN Route couldn't
exist without the SPA, and vise versa. Now, the SPA can be deployed
standalone - made public via the Storage Account URL - and after that
the CDN + Route can be deployed.



## [8.0.1](https://github.com/hamlet-io/engine-plugin-azure/compare/v8.0.0...v8.0.1) (2021-03-14)


### Bug Fixes

* Azure ResourceGroup Outputs ([#229](https://github.com/hamlet-io/engine-plugin-azure/issues/229)) ([7205ac3](https://github.com/hamlet-io/engine-plugin-azure/commit/7205ac34597ba3909bb46825774161b7c076b642))
* changelog generation ([8589f7d](https://github.com/hamlet-io/engine-plugin-azure/commit/8589f7d195ee3cc445fd7fe4310af32e4e7e948d))
* debug log output on util commands ([#234](https://github.com/hamlet-io/engine-plugin-azure/issues/234)) ([ed05ef0](https://github.com/hamlet-io/engine-plugin-azure/commit/ed05ef053c0dabc3104308452d07939921c2b576))
* invalid masterdata data ([#228](https://github.com/hamlet-io/engine-plugin-azure/issues/228)) ([6c48f80](https://github.com/hamlet-io/engine-plugin-azure/commit/6c48f80e5dc62d7a41db7c9f5a449b314caaa155))
* Invalid Module and Masterdata structures ([#223](https://github.com/hamlet-io/engine-plugin-azure/issues/223)) ([cc1eba1](https://github.com/hamlet-io/engine-plugin-azure/commit/cc1eba1a24e507dc7e875bf6a5c7137c97887096))
* test args for hamlet cmd ([#235](https://github.com/hamlet-io/engine-plugin-azure/issues/235)) ([5a00129](https://github.com/hamlet-io/engine-plugin-azure/commit/5a001297fe6a30906cb10601edbc9bdf1f2ceea6))
* **cicd:** jenkins pipeline structure ([#225](https://github.com/hamlet-io/engine-plugin-azure/issues/225)) ([34f512c](https://github.com/hamlet-io/engine-plugin-azure/commit/34f512c864507d4d7076073688becee33e35ebb0))
* move mock input types into azure provider ([2078622](https://github.com/hamlet-io/engine-plugin-azure/commit/20786228652125f7191ed292401300173f092f2a))


### Features

* add readme to repository ([11ab8e1](https://github.com/hamlet-io/engine-plugin-azure/commit/11ab8e1a1bb24465646833a97a7068a040d1fd8a))
* input seeders ([#224](https://github.com/hamlet-io/engine-plugin-azure/issues/224)) ([52b54d1](https://github.com/hamlet-io/engine-plugin-azure/commit/52b54d1290d36b1aeb7330d017c325e7b6f3c1cd))
* new ARM resource - KeyVault Keys ([e954e24](https://github.com/hamlet-io/engine-plugin-azure/commit/e954e24fd638e0c1fc45e5c575ebfefb9a9939ed))
* **ci:** Align azure testing with plugins and include junit ([#221](https://github.com/hamlet-io/engine-plugin-azure/issues/221)) ([272709a](https://github.com/hamlet-io/engine-plugin-azure/commit/272709a30391d2727168415c22cdba0f15e3ba1a))
* **db:** mysql as a engine type  ([5b90ac9](https://github.com/hamlet-io/engine-plugin-azure/commit/5b90ac92336cf733c82f22b89da249c9bb6174cb))



# [8.0.0](https://github.com/hamlet-io/engine-plugin-azure/compare/v7.0.0...v8.0.0) (2021-01-11)


### Bug Fixes

* **apigateway:** fix subset scopes for apigateway generation ([#187](https://github.com/hamlet-io/engine-plugin-azure/issues/187)) ([9546ded](https://github.com/hamlet-io/engine-plugin-azure/commit/9546dedd1991b64e70a6015f924451c8800dafe0))
* **apigateway:** only check for definition file once it has been retrieved ([#186](https://github.com/hamlet-io/engine-plugin-azure/issues/186)) ([5660205](https://github.com/hamlet-io/engine-plugin-azure/commit/566020566ce2cda16845ae0f84b445eebee95891))
* **baseline:** segment seed either does/doesn't exist ([25bec2f](https://github.com/hamlet-io/engine-plugin-azure/commit/25bec2f1986c14c0fef98b8f9831a0df0d4dbc3b)), closes [#202](https://github.com/hamlet-io/engine-plugin-azure/issues/202) [#202](https://github.com/hamlet-io/engine-plugin-azure/issues/202) [#202](https://github.com/hamlet-io/engine-plugin-azure/issues/202)
* **cdn:** ensure frontdoor names are unique globally ([#180](https://github.com/hamlet-io/engine-plugin-azure/issues/180)) ([1d7385b](https://github.com/hamlet-io/engine-plugin-azure/commit/1d7385be281c96a5344aa07fdb5cbae172606f25))
* **ci:** disable test suite ([d2039e3](https://github.com/hamlet-io/engine-plugin-azure/commit/d2039e3bdc3a5318c8d0817f436d3078e4ed1792)), closes [#216](https://github.com/hamlet-io/engine-plugin-azure/issues/216)
* **ci:** re-enable test suite ([1d4646e](https://github.com/hamlet-io/engine-plugin-azure/commit/1d4646ec07f8070a86b1e713b8eeddeae3afd91e)), closes [#216](https://github.com/hamlet-io/engine-plugin-azure/issues/216)
* **db:** allow vnet rule creation w/o service endpoint ([ee1b893](https://github.com/hamlet-io/engine-plugin-azure/commit/ee1b893c4f49875589ae421e8f0f36e0732d64a1))
* **lambda:** enforce global-uniqueness of name + max char limit ([#184](https://github.com/hamlet-io/engine-plugin-azure/issues/184)) ([ca16d14](https://github.com/hamlet-io/engine-plugin-azure/commit/ca16d142384bae370c46b704eef212deb0cca300))
* **outputs:** expect refrenced resource in outputs ([a2064da](https://github.com/hamlet-io/engine-plugin-azure/commit/a2064da1f5811e75728864bf0561c31464b69cba))
* **outputs:** fix retrieval of pseudo resource outputs ([#214](https://github.com/hamlet-io/engine-plugin-azure/issues/214)) ([26a5296](https://github.com/hamlet-io/engine-plugin-azure/commit/26a5296a797a24fcfae8f8ff653a916b1c105cb6))
* **referencedata:** load sku profile data inside getter func ([d020088](https://github.com/hamlet-io/engine-plugin-azure/commit/d020088beb892d55fc571d9b6bfd1e773518786a))
* **referencedata:** load vm image profiles inside getter func ([7301667](https://github.com/hamlet-io/engine-plugin-azure/commit/7301667b26b3f90bca61ae68fe1e76cc4b26ae1f))
* **spa:** invoke extensions on current occurrence ([2852307](https://github.com/hamlet-io/engine-plugin-azure/commit/285230729c386094cc4d4bbf7f52d019ac36a0d7))
* **storage:** fix storage account naming ([#190](https://github.com/hamlet-io/engine-plugin-azure/issues/190)) ([ddc8eb0](https://github.com/hamlet-io/engine-plugin-azure/commit/ddc8eb0255b3a001290867d20f34a4b789456ec7))
* **tests:** bring bastion name conventions into alignment with tests ([abf181a](https://github.com/hamlet-io/engine-plugin-azure/commit/abf181ae5ca1fcb837c9e38f4f3368526f9601a8))
* **tests:** mocked output ids should be in template scope ([d6fed00](https://github.com/hamlet-io/engine-plugin-azure/commit/d6fed00756276a5a2b4edb9b6a3aec496855b0e4))
* **tests:** standardise mock values ([0a53d87](https://github.com/hamlet-io/engine-plugin-azure/commit/0a53d871ddd084d7d4625914de9a23cb7e2ea198))
* :bug: combine "script" and "commandToExecute" settings into "commandToExecute" ([a4fd431](https://github.com/hamlet-io/engine-plugin-azure/commit/a4fd431c9958661eee66e59aa4f6a5251798ebdf))
* :bug: forwarding path not to start with / ([ab25ab9](https://github.com/hamlet-io/engine-plugin-azure/commit/ab25ab9427c96aa371cacb65153d9f23db722c71))
* :bug: timestamp now passed to settings as int ([bf29ed7](https://github.com/hamlet-io/engine-plugin-azure/commit/bf29ed792b902951061372b0ca0531807dcb71f2))
* :fire: removed erroneous bracket ([04edfc3](https://github.com/hamlet-io/engine-plugin-azure/commit/04edfc3876201f630aef44267013535b79266af5))
* add resource scope to scope obj ([8182078](https://github.com/hamlet-io/engine-plugin-azure/commit/8182078985fc12bf2f1e107db41e430a0769baf5))
* added a 60 minute timeout to build ([#203](https://github.com/hamlet-io/engine-plugin-azure/issues/203)) ([210e64e](https://github.com/hamlet-io/engine-plugin-azure/commit/210e64eaeb7374fca84a9404cea9e50f4f2d7e40))
* align scenario changes ([01f5d2c](https://github.com/hamlet-io/engine-plugin-azure/commit/01f5d2c449d9d1826045ccee7fb9e3508741031a))
* CDN Endpoint(s)  ([9ee5c8d](https://github.com/hamlet-io/engine-plugin-azure/commit/9ee5c8d07112807ca581cf4d13d0afa358f9f5e7))
* computecluster stage storage lookup values ([cd9beca](https://github.com/hamlet-io/engine-plugin-azure/commit/cd9becaf2511e2566d82d9fa0d05863374785d78))
* connectionString ARM function ([41ed280](https://github.com/hamlet-io/engine-plugin-azure/commit/41ed280985e6cfa5b9b8ebeeb546dd107ba29c8c))
* output constructions to fail elegantly ([bc1d389](https://github.com/hamlet-io/engine-plugin-azure/commit/bc1d389467b23a0032f73a124b9c0bbe9f16cd2f))
* remove call to unassigned variable ([023b386](https://github.com/hamlet-io/engine-plugin-azure/commit/023b38606b0d238dd55ad2dc52c3b2bbc842dd57))
* remove unused parentnames parameter ([dd465f4](https://github.com/hamlet-io/engine-plugin-azure/commit/dd465f46ff588209c16ec5488c86efa55fb2b97e))
* rg and sub ids are set if a parentId is provided ([0110719](https://github.com/hamlet-io/engine-plugin-azure/commit/01107198e7360aa313a416d59317ed8a07bfe190))
* sub/rg scoped outputs to correctly point to deployment resource outputs ([dcaf324](https://github.com/hamlet-io/engine-plugin-azure/commit/dcaf3249b596562a2b1d5d17964a0fa66f8df67b))
* use regionid global var instead of command line input ([#189](https://github.com/hamlet-io/engine-plugin-azure/issues/189)) ([3a14283](https://github.com/hamlet-io/engine-plugin-azure/commit/3a14283aa30964eb363d47ad144ed4293f3609e0))
* validate resourcepath ([50a6f44](https://github.com/hamlet-io/engine-plugin-azure/commit/50a6f4456b58542fbb20a789f905750ca854da22))


### Code Refactoring

* setup macro support for entrances ([953be20](https://github.com/hamlet-io/engine-plugin-azure/commit/953be200bbc8169a49469df48d3366179cd0e670))


### Features

* :sparkles: db secrets assignable in solution ([7de06eb](https://github.com/hamlet-io/engine-plugin-azure/commit/7de06eb7177170ac9c08e88cb699f2bb8600c714))
* :sparkles: linked db's to inject attributes as env variables ([a0a3c51](https://github.com/hamlet-io/engine-plugin-azure/commit/a0a3c51745ad2a04b07a2ab0ba9b24fd5e6c35db))
* changelog generation ([#219](https://github.com/hamlet-io/engine-plugin-azure/issues/219)) ([4bc8964](https://github.com/hamlet-io/engine-plugin-azure/commit/4bc8964b9fa6394a1031e33cc09388051a489f15))
* Component - computecluster ([#132](https://github.com/hamlet-io/engine-plugin-azure/issues/132)) ([2339f17](https://github.com/hamlet-io/engine-plugin-azure/commit/2339f17c7b164c35e3acd18d8424bf4f63c73b9c))
* introduce function to break down id path segments into scope ([702aaa0](https://github.com/hamlet-io/engine-plugin-azure/commit/702aaa00ff7d279f459f9d35807d4953a05f4e1a))
* microsoft.resources service to be available to all components ([d5a2a33](https://github.com/hamlet-io/engine-plugin-azure/commit/d5a2a332f4949930cdfb54069b5e7dd853a5ef28))
* migrate from fragments to extensions ([#212](https://github.com/hamlet-io/engine-plugin-azure/issues/212)) ([f6192b2](https://github.com/hamlet-io/engine-plugin-azure/commit/f6192b2ef4fc7b333e5ebef35a180d494ce8c4fc))
* refactor armResource to introduce scope + rework outputs ([bfd895e](https://github.com/hamlet-io/engine-plugin-azure/commit/bfd895ed77293b253d349d0f8c75b36ef9dc5282))
* **baseline:** allow multiple keyVaultAdmins ([#178](https://github.com/hamlet-io/engine-plugin-azure/issues/178)) ([21bb463](https://github.com/hamlet-io/engine-plugin-azure/commit/21bb46310b9444d7a993db618bcd6ac4b8e15974))
* **resources:** incorporate scope into azureResourceProfiles ([#198](https://github.com/hamlet-io/engine-plugin-azure/issues/198)) ([0553404](https://github.com/hamlet-io/engine-plugin-azure/commit/05534041dde69cf3ddf9953f7e5b0b1bb3acc436))


### BREAKING CHANGES

* setup marco names do not suppor the current naming
format



# 7.0.0 (2020-04-25)



