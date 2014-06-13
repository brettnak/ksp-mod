# KSP Plugin Management
---

A simple tool for adding/changing plugins for Kerbal Space Program.

## Dependencies

  - ruby 1.9.3 (Probably works on >2.0 but not tested)
  - bundler (`gem install bundler`)

## Installation

Note: This will change after R0 to be more friendly.

  - Clone the repository
  - Install the bundle (`bundle`)

## Usage

```shell
bundle exec ruby ./ksp_mod.rb <options> <command> <command-args>

options:

  - options: -v[v[v[v]]]
    You may specify -v, vv, vvv depending on the level of verbosity you wish.

command:

  - list
    Show a list of all the plugins that ksp_mod.rb knows how to install.

  - install <mod>
    Install <mod>

  - modpack <Kmodfile path>
    Install all the files listed in Kmodfile. See below for syntax.

  - stage <mod>
    Do everything that install does but _don't_ copy it into the KSP folder.

  - uninstall <mod>
    NOT IMPLEMENTED.  Uninstall a mod.

```

### Kmodfile
Kmodfile is a YAML file that describes what mods to install:

```yaml
mods:
  - module_manager
  - toolbar_plugin
  - precise_node
  - ... etc
```

Take a look at ./Kmodfile for an example.

## Roadmap

#### TODO 0.0.1

  - [x] ksp_mod install plugin
  - [x] ksp_mod list
  - [x] Kmodfile

#### TODO 0.0.2

  - [x] ksp_mod install plugin[@version]
  - [ ] ksp_mod uninstall plugin
  - [ ] KSP_HOME detection

#### TODO 0.1.0

  - version: `>~ 0.1.0`
  - [ ] Dependency management
  - [ ] Installed Plugin Detection

#### TODO R2

  - version: `>~ 0.2.0`
  - [ ] ksp_mod refresh - Command to reload the KPluginSet after editing
