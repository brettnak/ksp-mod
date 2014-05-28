module KspMod::Shell
  class Base
    include KspMod::Loggable

    def initialize
      @dryrun = KspMod.config.dryrun
    end

    # Detect the proper subclass for this system
    def self.new_for_system
      shell_class = determine_ksp_shell

      KspMod.logger.debug( "Set shell to `#{shell_class}`.  Based on fs_type: #{KspMod::FS_TYPE}")
      return shell_class.new
    end

    def self.determine_ksp_shell
      Kernel.require( './lib/shells/sh' )
      return KspMod::Shell::Sh
    end

    # Provided by native ruby
    def mv( source, dest )
    end

    # Provided by native ruby
    def cp( source, dest )
    end

    # Provided by native ruby
    def mkdir( dir )
      if @dryrun
        log.info( "DRYRUN" ) { "Shell would create `#{dir}`" }
        return
      end

      log.debug( "FS" ) { "Shell is creating `#{dir}`" }
      FileUtils.mkdir_p( dir ) unless @dryrun
    end

    def unzip( file )
      raise NotImplementedError, "#{self.class.to_s} cannot unzip.  You need subclass such as KspMod::Shell::Sh"
    end

    def git
      raise NotImplementedError, "#{self.class.to_s} cannot call git.  You need subclass such as KspMod::Shell::Sh"
    end
  end
end
