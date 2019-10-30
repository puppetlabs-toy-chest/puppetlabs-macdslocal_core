
# macdslocal_core

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with macdslocal_core](#setup)
    * [Setup requirements](#setup-requirements)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Deprecation - The development status of this module](#deprecation)

## Description

The macdslocal_core module is used to manage local OS X Directory Service objects.

## Setup

### Setup Requirements **OPTIONAL**

The types and providers rely on the CFPropertyList gem. If you are using `puppet-agent` packages, then those prerequisities are already satisfied on OS X.

## Reference

Please see REFERENCE.md for the reference documentation.

This module is documented using Puppet Strings.

For a quick primer on how Strings works, please see [this blog post](https://puppet.com/blog/using-puppet-strings-generate-great-documentation-puppet-modules) or the [README.md](https://github.com/puppetlabs/puppet-strings/blob/master/README.md) for Puppet Strings.

To generate documentation locally, run
```
bundle install
bundle exec puppet strings generate ./lib/**/*.rb
```
This command will create a browsable `_index.html` file in the `doc` directory. The references available here are all generated from YARD-style comments embedded in the code base. When any development happens on this module, the impacted documentation should also be updated.

## Limitations

This module is only available on OS X platforms that have the CFPropertyList gem installed.

## Deprecation

When the `macdslocal` code was removed from Puppet in Puppet Platform 6 and extracted to this module it was effectively deprecated and is no longer under active develepment.

This repository has been archived, so you can still fork it and use the code. If you need help or have questions about this module, please join our [Community Slack](https://slack.puppet.com/).
