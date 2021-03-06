#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'logger'
require 'os'
require 'fileutils'
require 'httparty'
require 'open3'

module KspMod
  ROOT    = File.expand_path( "..", __FILE__ )
  FS_TYPE = OS.posix? ? :posix  : :windows

  class << self
    attr_accessor :config, :logger, :dryrun
  end

  KspMod.logger = ::Logger.new( STDOUT )
  KspMod.logger.level = ::Logger::WARN

  def KspMod.cli
    cli_loglevel

    # Load the configuration
    initial_config = File.expand_path( File.join( '..', 'config.yml') , __FILE__ )

    KspMod.config = KspMod::Config.new( initial_config )

    KspMod.logger.info("config_search: " + KspMod.config.config_search.inspect )
    KspMod.logger.info("mod_search: " + KspMod.config.mod_search.inspect )
    KspMod.logger.info("dryrun: " + KspMod.config.dryrun.inspect )
    KspMod.logger.info("ksp root: " + KspMod.config.ksp_root.inspect )

    cli = KspMod::Cli.new
    cli.main
  end

  def KspMod.cli_loglevel
    ARGV.each do |arg|
      if arg =~ /-v+/
        ARGV.delete( arg )

        level = arg.size - 1
        level = [ ::Logger::ERROR - level, 0 ].max

        KspMod.logger.level = level
        break
      end
    end
  end
end

require './lib/util/loggable'
require './lib/shells/base'
require './lib/config'
require './lib/mod'
require './lib/cli'


if __FILE__ == $0
  KspMod.cli
end
