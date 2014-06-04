#!/usr/bin/env ruby

require 'rubygems'
require 'trollop'
require 'erb'

class KspModTemplateGenerator

  def initialize
    @options = options
  end

  def generate
    set_vars
    modfile = template.result( binding )

    File.open( destination_file, 'w' ) do |f|
      f.write( modfile )
    end

    puts "Wrote: #{destination_file}"
    puts "To add the files section of your template, stage this mod:"

    stage_dir = "~/.ksp_mod/staging/#{@name}-#{@internal_version}"
    puts "$ bundle exec ruby ./ksp_mod.rb -vvv stage #{@name} && tree #{stage_dir}"
  end

  def set_vars
    @name             = options[:name]
    @human_name       = options[:hname]
    @url              = options[:url]
    @internal_version = options[:iversion]
    @external_version = options[:eversion] || @internal_version

    iversion = @internal_version.split( '.' ) rescue nil
    @internal_version_major = iversion[0] rescue nil
    @internal_version_minor = iversion[1] rescue nil
    @internal_version_patch = iversion[2] rescue nil

    if @name.nil? || @name.empty?
      Trollop::die "--name must be present"
    end

    if @internal_version.nil? || @internal_version.nil?
      Trollop::die "--iversion must be set"
    end

    if @internal_version.split(".").size < 3
      Trollop::die "--iversion major.minor.patch, eg: 0.0.1"
    end

    if @url.nil? || @url.empty?
      Trollop::die "--url is required"
    end
  end

  def destination_file
    name = "#{@name}-v#{@external_version}.kspmod.yml"
    path = File.join( "mods", name )

    return path
  end

  def template
    return @template if @template

    rel  = File.join( "..", "template", "template.kspmod.yml.erb" )
    file = File.expand_path( rel, __FILE__ )

    erb_template = File.read( file )

    @template = ERB.new( erb_template )
  end

  def options
    return @options if @options

    opts = Trollop::options do
      version "0.0.1 (c) 2014 Brett Nakashima + various authors"
      banner <<-EOB
Generate a template file for a KSP mod.  The template will be generated in './mods'

Usage:
EOB
      opt :name, "[required] Internal Name.  A more computer friendly name with no whitespace.  eg: kw_rocketry", :type => :string
      opt :iversion, "[required] Internal version.  A version in the form of major.minor.patch.  eg: 0.0.1", :type => :string
      opt :url, "[required] URL where the archive resides.  Should be a permanent url.", :type => :string
      opt :hname, "Human Name.  The human name of this mod.", :type => :string, :short => "N"
      opt :eversion, "External version, the mod developers version.", :type => :string
    end

    @options = opts
    return opts
  end
end

if __FILE__ == $0
  gen = KspModTemplateGenerator.new
  gen.generate
end
