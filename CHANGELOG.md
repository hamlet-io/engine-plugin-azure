# [0.0.0](https://github.com/hamlet-io/engine-plugin-aws/compare/v7.0.0...v0.0.0) (2021-01-11)


### Bug Fixes

* :bug: combine "script" and "commandToExecute" settings into "commandToExecute" ([a4fd431](https://github.com/hamlet-io/engine-plugin-aws/commit/a4fd431c9958661eee66e59aa4f6a5251798ebdf))
* :bug: forwarding path not to start with / ([ab25ab9](https://github.com/hamlet-io/engine-plugin-aws/commit/ab25ab9427c96aa371cacb65153d9f23db722c71))
* :bug: timestamp now passed to settings as int ([bf29ed7](https://github.com/hamlet-io/engine-plugin-aws/commit/bf29ed792b902951061372b0ca0531807dcb71f2))
* :fire: removed erroneous bracket ([04edfc3](https://github.com/hamlet-io/engine-plugin-aws/commit/04edfc3876201f630aef44267013535b79266af5))
* add resource scope to scope obj ([8182078](https://github.com/hamlet-io/engine-plugin-aws/commit/8182078985fc12bf2f1e107db41e430a0769baf5))
* added a 60 minute timeout to build ([#203](https://github.com/hamlet-io/engine-plugin-aws/issues/203)) ([210e64e](https://github.com/hamlet-io/engine-plugin-aws/commit/210e64eaeb7374fca84a9404cea9e50f4f2d7e40))
* align scenario changes ([01f5d2c](https://github.com/hamlet-io/engine-plugin-aws/commit/01f5d2c449d9d1826045ccee7fb9e3508741031a))
* CDN Endpoint(s)  ([9ee5c8d](https://github.com/hamlet-io/engine-plugin-aws/commit/9ee5c8d07112807ca581cf4d13d0afa358f9f5e7))
* computecluster stage storage lookup values ([cd9beca](https://github.com/hamlet-io/engine-plugin-aws/commit/cd9becaf2511e2566d82d9fa0d05863374785d78))
* connectionString ARM function ([41ed280](https://github.com/hamlet-io/engine-plugin-aws/commit/41ed280985e6cfa5b9b8ebeeb546dd107ba29c8c))
* output constructions to fail elegantly ([bc1d389](https://github.com/hamlet-io/engine-plugin-aws/commit/bc1d389467b23a0032f73a124b9c0bbe9f16cd2f))
* remove call to unassigned variable ([023b386](https://github.com/hamlet-io/engine-plugin-aws/commit/023b38606b0d238dd55ad2dc52c3b2bbc842dd57))
* remove unused parentnames parameter ([dd465f4](https://github.com/hamlet-io/engine-plugin-aws/commit/dd465f46ff588209c16ec5488c86efa55fb2b97e))
* rg and sub ids are set if a parentId is provided ([0110719](https://github.com/hamlet-io/engine-plugin-aws/commit/01107198e7360aa313a416d59317ed8a07bfe190))
* sub/rg scoped outputs to correctly point to deployment resource outputs ([dcaf324](https://github.com/hamlet-io/engine-plugin-aws/commit/dcaf3249b596562a2b1d5d17964a0fa66f8df67b))
* **apigateway:** fix subset scopes for apigateway generation ([#187](https://github.com/hamlet-io/engine-plugin-aws/issues/187)) ([9546ded](https://github.com/hamlet-io/engine-plugin-aws/commit/9546dedd1991b64e70a6015f924451c8800dafe0))
* **apigateway:** only check for definition file once it has been retrieved ([#186](https://github.com/hamlet-io/engine-plugin-aws/issues/186)) ([5660205](https://github.com/hamlet-io/engine-plugin-aws/commit/566020566ce2cda16845ae0f84b445eebee95891))
* **baseline:** segment seed either does/doesn't exist ([25bec2f](https://github.com/hamlet-io/engine-plugin-aws/commit/25bec2f1986c14c0fef98b8f9831a0df0d4dbc3b)), closes [#202](https://github.com/hamlet-io/engine-plugin-aws/issues/202) [#202](https://github.com/hamlet-io/engine-plugin-aws/issues/202) [#202](https://github.com/hamlet-io/engine-plugin-aws/issues/202)
* **cdn:** ensure frontdoor names are unique globally ([#180](https://github.com/hamlet-io/engine-plugin-aws/issues/180)) ([1d7385b](https://github.com/hamlet-io/engine-plugin-aws/commit/1d7385be281c96a5344aa07fdb5cbae172606f25))
* **ci:** disable test suite ([d2039e3](https://github.com/hamlet-io/engine-plugin-aws/commit/d2039e3bdc3a5318c8d0817f436d3078e4ed1792)), closes [#216](https://github.com/hamlet-io/engine-plugin-aws/issues/216)
* **ci:** re-enable test suite ([1d4646e](https://github.com/hamlet-io/engine-plugin-aws/commit/1d4646ec07f8070a86b1e713b8eeddeae3afd91e)), closes [#216](https://github.com/hamlet-io/engine-plugin-aws/issues/216)
* **db:** allow vnet rule creation w/o service endpoint ([ee1b893](https://github.com/hamlet-io/engine-plugin-aws/commit/ee1b893c4f49875589ae421e8f0f36e0732d64a1))
* **lambda:** enforce global-uniqueness of name + max char limit ([#184](https://github.com/hamlet-io/engine-plugin-aws/issues/184)) ([ca16d14](https://github.com/hamlet-io/engine-plugin-aws/commit/ca16d142384bae370c46b704eef212deb0cca300))
* **tests:** mocked output ids should be in template scope ([d6fed00](https://github.com/hamlet-io/engine-plugin-aws/commit/d6fed00756276a5a2b4edb9b6a3aec496855b0e4))
* use regionid global var instead of command line input ([#189](https://github.com/hamlet-io/engine-plugin-aws/issues/189)) ([3a14283](https://github.com/hamlet-io/engine-plugin-aws/commit/3a14283aa30964eb363d47ad144ed4293f3609e0))
* validate resourcepath ([50a6f44](https://github.com/hamlet-io/engine-plugin-aws/commit/50a6f4456b58542fbb20a789f905750ca854da22))
* **outputs:** expect refrenced resource in outputs ([a2064da](https://github.com/hamlet-io/engine-plugin-aws/commit/a2064da1f5811e75728864bf0561c31464b69cba))
* **outputs:** fix retrieval of pseudo resource outputs ([#214](https://github.com/hamlet-io/engine-plugin-aws/issues/214)) ([26a5296](https://github.com/hamlet-io/engine-plugin-aws/commit/26a5296a797a24fcfae8f8ff653a916b1c105cb6))
* **referencedata:** load sku profile data inside getter func ([d020088](https://github.com/hamlet-io/engine-plugin-aws/commit/d020088beb892d55fc571d9b6bfd1e773518786a))
* **referencedata:** load vm image profiles inside getter func ([7301667](https://github.com/hamlet-io/engine-plugin-aws/commit/7301667b26b3f90bca61ae68fe1e76cc4b26ae1f))
* **spa:** invoke extensions on current occurrence ([2852307](https://github.com/hamlet-io/engine-plugin-aws/commit/285230729c386094cc4d4bbf7f52d019ac36a0d7))
* **storage:** fix storage account naming ([#190](https://github.com/hamlet-io/engine-plugin-aws/issues/190)) ([ddc8eb0](https://github.com/hamlet-io/engine-plugin-aws/commit/ddc8eb0255b3a001290867d20f34a4b789456ec7))
* **tests:** bring bastion name conventions into alignment with tests ([abf181a](https://github.com/hamlet-io/engine-plugin-aws/commit/abf181ae5ca1fcb837c9e38f4f3368526f9601a8))
* **tests:** standardise mock values ([0a53d87](https://github.com/hamlet-io/engine-plugin-aws/commit/0a53d871ddd084d7d4625914de9a23cb7e2ea198))


### Code Refactoring

* setup macro support for entrances ([953be20](https://github.com/hamlet-io/engine-plugin-aws/commit/953be200bbc8169a49469df48d3366179cd0e670))


### Features

* :sparkles: db secrets assignable in solution ([7de06eb](https://github.com/hamlet-io/engine-plugin-aws/commit/7de06eb7177170ac9c08e88cb699f2bb8600c714))
* :sparkles: linked db's to inject attributes as env variables ([a0a3c51](https://github.com/hamlet-io/engine-plugin-aws/commit/a0a3c51745ad2a04b07a2ab0ba9b24fd5e6c35db))
* Component - computecluster ([#132](https://github.com/hamlet-io/engine-plugin-aws/issues/132)) ([2339f17](https://github.com/hamlet-io/engine-plugin-aws/commit/2339f17c7b164c35e3acd18d8424bf4f63c73b9c))
* refactor armResource to introduce scope + rework outputs ([bfd895e](https://github.com/hamlet-io/engine-plugin-aws/commit/bfd895ed77293b253d349d0f8c75b36ef9dc5282))
* **baseline:** allow multiple keyVaultAdmins ([#178](https://github.com/hamlet-io/engine-plugin-aws/issues/178)) ([21bb463](https://github.com/hamlet-io/engine-plugin-aws/commit/21bb46310b9444d7a993db618bcd6ac4b8e15974))
* **resources:** incorporate scope into azureResourceProfiles ([#198](https://github.com/hamlet-io/engine-plugin-aws/issues/198)) ([0553404](https://github.com/hamlet-io/engine-plugin-aws/commit/05534041dde69cf3ddf9953f7e5b0b1bb3acc436))
* introduce function to break down id path segments into scope ([702aaa0](https://github.com/hamlet-io/engine-plugin-aws/commit/702aaa00ff7d279f459f9d35807d4953a05f4e1a))
* microsoft.resources service to be available to all components ([d5a2a33](https://github.com/hamlet-io/engine-plugin-aws/commit/d5a2a332f4949930cdfb54069b5e7dd853a5ef28))
* migrate from fragments to extensions ([#212](https://github.com/hamlet-io/engine-plugin-aws/issues/212)) ([f6192b2](https://github.com/hamlet-io/engine-plugin-aws/commit/f6192b2ef4fc7b333e5ebef35a180d494ce8c4fc))


### BREAKING CHANGES

* setup marco names do not suppor the current naming
format



