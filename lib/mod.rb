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

  def install
    log.info( "Installing #{@name} @ #{version_s}" )
    set_shell

    create_staging_directory
    download
    unpack
    copy_files
  end

  def create_staging_directory
    log.debug( "Creating staging directory #{staging_directory}" )
    @shell.mkdir( staging_directory )
  end

  def download
    log.debug( "Downloading archive from: #{@url}" )
    log.debug( "Downloading archive to: #{archive_location}" )
  end

  def unpack
    log.debug( "Unpacking" )

  end

  def copy_files
    log.debug( "Copying files" )
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
    attr_accessor :src, :dest

    # str_hash -
    #   'src'  =>
    #   'dest' =>
    def initialize( str_hash )
      @src  = str_hash['src']
      @dest = str_hash['dest']
    end
  end
end
