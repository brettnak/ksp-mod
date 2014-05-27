#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'logger'
require 'os'

module KspMod
  ROOT    = File.expand_path( "..", __FILE__ )
  FS_TYPE = OS.posix? ? :posix  : :windows

  class << self
    attr_accessor :config, :logger
  end

  KspMod.logger = ::Logger.new( STDOUT )
  KspMod.logger.level = ::Logger::DEBUG

  def KspMod.cli
    # Load the configuration
    initial_config = File.expand_path( File.join( '..', 'config.yml') , __FILE__ )

    KspMod.config = KspMod::Config.new( initial_config )

    KspMod.logger.info("config_search: " + KspMod.config.config_search.inspect )
    KspMod.logger.info("mod_search: " + KspMod.config.mod_search.inspect )

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
