class KspMod::Cli
  attr_accessor :mods

  def initialize
    @mods = []
  end

  def list
    self.load

    @mods.each do |mod|
      puts mod.to_s
    end
  end

  def install
  end

  def uninstall
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
    KspMod.logger.info "Module directory discovered: #{initial_dir}"

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

      @mods << KspMod::Mod.new( f )
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
      puts "install"
    when :uninstall
      puts "uninstall"
    else
      warn "I don't recognize #{command} as a valid command."
      warn "I support only `list`, `install`, and `uninstall`"
      exit 1
    end
  end
end
