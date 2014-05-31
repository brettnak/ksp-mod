class KspMod::Cli
  include KspMod::Loggable

  attr_accessor :mods

  def initialize
    @mods = {}
  end

  def list
    self.load

    # TODO: Possibly only show the latest version?
    @mods.each_pair do |mod_name, versions|
      print mod_name + " "
      print "("
      print versions.keys.join( " ,")
      puts ")"
    end
  end

  # options - {}
  #   :stage - Do everything but do not copy into the KSP home directory
  #
  # TODO: Raise error if the mod could not be found.
  def install( options = {} )
    self.load

    @mods.each do |modname|
      log.debug "Did index: #{modname}"
    end

    modname = options[:mod] || ARGV.shift

    if modname.nil?
      warn "You must specify a mod"
      exit 1
    end

    mod_version = modname.split("@")
    mod = mod_version.size == 2 ? select_mod_version( mod_version.first, mod_version.last ) : select_mod_max_version( mod_version.first )

    mod.install( options )
  end

  def uninstall
  end

  def modpack
    file = ARGV.shift
    modfile = YAML::load_file( file )

    modfile['mods'].each do |mod|
      log.info "Installing #{mod}"
      self.install( :mod => mod.strip, :stage => true )
    end
  end

  def select_mod_version( modname, human_version )
    return @mods[modname][human_version]
  end

  def select_mod_max_version( modname )
    # version is a human version, not a comparable version
    sorted_by_version = @mods[modname].values.sort { |a,b| a.version_i <=> b.version_i }
    return sorted_by_version.last
  end

  # options -
  #  :dir - Instead of using KspMod.config.mod_search as the
  #         initial path, use this one instead.
  #         Allows for recursive loading.
  def load( options = {} )

    unless options.has_key?( :dir )
      dirs = []
      KspMod.config.mod_search.each do |dir|
        dirs << self.load( :dir => dir )
      end

      return dirs
    end

    initial_dir = options[:dir]
    log.info "Module directory discovered: #{initial_dir}"

    return [] unless File.exists?( initial_dir )

    res = [initial_dir]

    Dir.foreach( initial_dir ) do |f|
      # Don't load . & ..
      if f =~ /^\.\.?$/
        next
      end

      f = File.expand_path( f, initial_dir )

      if File.directory?( f )
        res = self.load( :dir => f ) + res
        next
      end

      next unless f =~ /\.kspmod\.yml/

      mod = KspMod::Mod.new( f )

      log.debug "Indexed module: #{mod.name.strip}"
      @mods[mod.name.strip] = { mod.version_s => mod }
    end

    return res
  end

  # Entry point after creating a new CLI
  def main
    command = ARGV.shift
    command = command.strip.to_sym rescue nil

    case command
    when :list
      self.list
    when :install
      self.install
    when :stage
      self.install( :stage => true )
    when :modpack
      self.modpack
    when :uninstall
      puts "uninstall"
    else
      warn "I don't recognize #{command} as a valid command."
      warn "I support only `list`, `install`, `modpack`, `stage`, and `uninstall`"
      exit 1
    end
  end
end
