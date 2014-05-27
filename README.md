# KSP Plugin Management
---

#### Warning: Pre-Alpha Software

A simple tool for adding/changing plugins for Kerbal Space Program.

## Dependencies

  - ruby 1.9.3 (Probably works on >2.0 but not tested)
  - bundler (`gem install bundler`)

## Installation

Note: This will change after R0 to be

  - Clone the repository
  - Install the bundle (`bundle`)

## Usage

```shell
bundle exec ruby ./ksp_mod.rb list
```

## Roadmap

#### TODO R0

  - version: `>~ 0.0.1`
  - [ ] ksp_mod install plugin[@version]
  - [ ] ksp_mod uninstall plugin[@version]
  - [ ] KSP_HOME detection
  - [x] ksp_mod list

#### TODO R1

  - version: `>~ 0.1.0`
  - [ ] Dependency management
  - [ ] Installed Plugin Detection

#### TODO R2

  - version: `>~ 0.2.0`
  - [ ] KPluginSet (Similar to Gemfile)
  - [ ] ksp_mod refresh - Command to reload the KPluginSet after editing
