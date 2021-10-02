# Hamlet Deploy Plugin - Azure

This is a Hamlet Deploy plugin repository. It extends the Hamlet Deploy application with integration with the Microsoft Azure cloud provider.

This repository includes a collection of hamlet plugins specific to Azure

| Name           | Directory       | Description                        |
|----------------|-----------------|------------------------------------|
| azure          | azure           | Core azure functionality           |
| azuretest      | azuretest/      | Testing for azure functionality    |
| azurediagrams  | azurediagrams/  | Diagram support for azure services |

See https://docs.hamlet.io for more info on Hamlet Deploy

## Installation

The Azure plugin is included as part of the standard hamlet installation. For details on installing hamlet see the [install guide](https://docs.hamlet.io/docs/getting-started/install) on our docs site.

### Alternative installs

The engine install method is our recommended approach however you can also install the plugin through some additional methods

#### CMDB plugin

If you would like to include it we recommended adding it as a plugin in your CMDB. In your solution.json file add the following to install the latest release of the plugin

```json
{
    "Segment" : {
        "Plugins" : {
            "azure" : {
                "Enabled" : true,
                "Name" : "azure",
                "Priority" : 10,
                "Required" : true,
                "Source" : "git",
                "Source:git" : {
                    "Url" : "https://github.com/hamlet-io/engine-plugin-azure",
                    "Ref" : "master",
                    "Path" : "azure/"
                }
            }
        }
    }
}
```

Then run the setup command to install the plugin from the segment you have the plugin installed under

```bash
hamlet setup
```

To update re-rerun the hamlet setup command to get the latest changes

#### Local clone

Run the following commands in your hamlet workspace to install a local copy

```bash
azure_clone_dir=< a path where you want to clone the plugin>
git clone "https://github.com/hamlet-io/engine-plugin-azure"
export GENERATION_PLUGIN_DIRS="${GENERATION_PLUGIN_DIRS};${azure_clone_dir}"
```

Then to include the plugin as part of your hamlet commands

```bash
hamlet -p azure -f arm < your command>
```

Or if you want to use it for all hamlet commands

```bash
export GENERATION_PROVIDERS="azure"
export GENERATION_FRAMEWORK="arm"
```

To update cd into the repo where you cloned the plugin and run `git pull` ( hamlet plugins don't need to be compiled)

### Usage

This is a plugin for the hamlet engine and won't work by itself. Usage of this provider requires the other parts of hamlet deploy

See https://docs.hamlet.io for more information

### Contributing

When contributing to hamlet we recommend installing this plugin using the **Local Clone** method above using a fork of the repository

#### Testing

The plugin includes a test suite which generates a collection of deployments and checks that their content aligns with what is expected

To run the test suite locally install the hamlet cli and use the provider testing included

```bash

# install cli
pip install hamlet

# run the tests
hamlet -p azure -p azuretest -f arm deploy run-deployments
```

This will run all of the tests and provide you the results. We also run this on all Pull requests made to the repository

##### Submitting Changes

Changes to the plugin are made through pull requests to this repo and all commits should use the [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/) format
This allows us to generate changelogs automatically and to understand what changes have been made
