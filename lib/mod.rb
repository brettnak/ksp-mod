class KspMod::Mod
  include KspMod::Loggable

  attr_accessor \
    :name,
    :version,
    :url,
    :files,
    :after_install,
    :after_uninstall,
    :dependencies,
    :archive_type

  attr_reader :shell

  # Public:
  #
  # yaml_path - Path to the Yaml file to install
  #
  # Returns Ksp::Mod instance
  def initialize( yaml_path )
    log.info( "Found module: #{yaml_path}" )
    parse( yaml_path )
  end

  # options - {}
  #   :stage - Do everything but do not copy into the KSP home directory
  def install( options = {} )
    log.info( "Installing #{@name} @ #{version_s}" )
    set_shell

    create_staging_directory
    download
    unpack
    copy_files unless options[:stage]
  end

  def create_staging_directory
    log.debug( "Creating staging directory #{staging_directory}" )
    @shell.mkdir( staging_directory )
  end

  def download
    log.info( "Downloading Archive" )
    log.debug( "Downloading archive from: #{@url}" )
    log.debug( "Downloading archive to: #{archive_location}" )

    @shell.download( @url, archive_location )
  end

  def unpack
    log.info( "Unpacking Archive" )
    log.debug( "Unpacking Archive to #{staging_directory}" )

    # TODO: use archive_type to determine correct unpacking method for @shell
    @shell.unzip( archive_location, staging_directory )
  end

  def copy_files
    log.info( "Copying files" )

    @files.each do |file|
      file.install( @shell, staging_directory )
    end
  end

  def uninstall
    set_shell
  end

  def staging_directory
    return File.join( KspMod.config.staging_directory, "#{@name}-#{version_s}" )
  end

  def parse( yaml_path )
    desc = YAML::load_file( yaml_path )

    @name            = desc['name']
    @human_name      = desc['human_name']
    @version         = desc['version']
    @url             = desc['url']
    @after_install   = desc['after_install']
    @after_uninstall = desc['after_uninstall']
    @dependencies    = desc['dependencies']
    @archive_type    = desc['archive_type']
    files            = desc['files']

    @files = files.map {|f| ManagedPath.new(f)}
  end

  def to_s
    return "%s (%s)" % [ name, version_s ]
  end

  def version_s
    "%d.%d.%d" % [ @version['major'], @version['minor'], @version['patch'] ]
  end

  def version_i
    ( "%04d%04d%04d" % [ @version['major'], @version['minor'], @version['patch'] ] ).to_i
  end

  def archive_location
    return File.join( staging_directory, archive_basename )
  end

  # Might need/want to change this so keep it factored out in here
  def archive_basename
    return "archive.zip"
  end

  def set_shell
    @shell = KspMod::Shell::Base.new_for_system
  end

  class ManagedPath
    include KspMod::Loggable
    attr_accessor :src, :dest

    # str_hash -
    #   'src'  =>
    #   'dest' =>
    def initialize( str_hash )
      @src  = str_hash['src']
      @dest = str_hash['dest']
    end

    def install( shell, src_stage )
      log.info( "Installing file #{@src} to #{@dest}")

      abs_src  = File.expand_path( @src,  src_stage )
      abs_dest = File.expand_path( @dest, KspMod.config.ksp_root )

      dirname = File.dirname( abs_dest )

      # Sometimes we need folders in folders that haven't been made
      shell.mkdir( dirname )

      shell.cp( abs_src, abs_dest )
    end
  end
end
