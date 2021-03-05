## Hamlet Deploy Plugin - Azure Provider

This is a Hamlet Deploy plugin repository. It extends the Hamlet Deploy application with integration with the Azure cloud provider.

See https://docs.hamlet.io for more info on Hamlet Deploy

### Installation

```bash
git clone https://github.com/hamlet-io/engine-plugin-azure.git
```

### Configuration

Update the GENERATION_PLUGIN_DIRS environment variable with a fully qualified path to the local plugin.

```bash
export GENERATION_PLUGIN_DIRS="${GENERATION_PLUGIN_DIRS};/path/to/plugin/azure"
```

### Update

To manually perform an update on this module, simply pull down the latest changes with git.

```bash
cd /path/to/plugin/azure
git pull
```

There are no binaries to build or update.

### Usage

Usage of this provider requires the other parts of the Hamlet Deploy application.

It is recommended that you use the Hamlet Deploy container for this.

See https://docs.hamlet.io for more information.
