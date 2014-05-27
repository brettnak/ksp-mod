
class KspMod::Mod

  attr_accessor \
    :name,
    :version,
    :url,
    :files,
    :after_install,
    :after_uninstall,
    :dependencies

  # Public:
  #
  # yaml_path - Path to the Yaml file to install
  #
  # Returns Ksp::Mod instance
  def initialize( yaml_path )
    KspMod.logger.info( "Found module: #{yaml_path}" )
    parse( yaml_path )
  end

  def install
    # Create the staging dir
  end

  def uninstall
  end

  def parse( yaml_path )
    desc = YAML::load_file( yaml_path )

    @name            = desc['name']
    @version         = desc['version']
    @url             = desc['url']
    @after_install   = desc['after_install']
    @after_uninstall = desc['after_uninstall']
    @dependencies    = desc['dependencies']
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
