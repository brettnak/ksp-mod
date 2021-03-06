class KspMod::Config

  attr_accessor \
    :mod_search,
    :config_search,
    :staging_directory,
    :loaded_configs,
    :ksp_root,
    :dryrun

  TEMPLATE_REPLACEMENTS = {
    "v!KSP_MOD_ROOT" => KspMod::ROOT,
    "v!HOME" => Dir.home,
  }

  def initialize( initial_config_yaml )
    @loaded_configs = []
    @mod_search = []
    @config_search = []
    @dryrun = false

    add_config_file( initial_config_yaml )

    @config_search.each do |config_file|
      add_config_file( config_file )
    end
  end

  def add_config_file( config_file )
    config_file = File.absolute_path( config_file )
    return false if @loaded_configs.include?( config_file )
    return false unless File.exists?( config_file )

    @loaded_configs << config_file

    config = YAML::load_file( config_file )

    msp    = config.fetch( 'mod_search_path', [] )
    csp    = config.fetch( 'config_search_path', [] )
    sd     = config.fetch( 'staging_directory', nil )
    kroot  = config.fetch( 'ksp_root', nil )
    dryrun = config.fetch( 'dryrun', :not_set )

    msp.map! { |p| template_path_entry(p) }
    csp.map! { |p| template_path_entry(p) }

    msp.reverse!
    csp.reverse!

    sd = template_path_entry( sd ) unless sd.nil?
    kroot = template_path_entry( kroot ) unless kroot.nil?

    @mod_search        = msp + @mod_search
    @staging_directory = sd unless sd.nil?
    @ksp_root          = kroot unless kroot.nil?
    @config_search    += csp
    @dryrun            = !!dryrun unless dryrun == :not_set
  end

  def template_path_entry( path_entry )
    path_entry = path_entry.strip

    TEMPLATE_REPLACEMENTS.each do |key, replacement|
      path_entry = path_entry.gsub( key, replacement )
    end

    return path_entry
  end
end
