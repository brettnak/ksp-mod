#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'awesome_print'

module KspMod
  ROOT = File.expand_path( "..", __FILE__ )

  class << self
    attr_accessor :config
  end

  def KspMod.cli
    # Load the configuration
    initial_config = File.expand_path( File.join( '..', 'config.yml') , __FILE__ )

    KspMod.config = KspMod::Config.new( initial_config )
    ap KspMod.config.config_search
    ap KspMod.config.mod_search

    cli = KspMod::Cli.new
    cli.main
  end
end

require './lib/shells/base'
require './lib/config'
require './lib/mod'
require './lib/cli'

if __FILE__ == $0
  KspMod.cli
end
