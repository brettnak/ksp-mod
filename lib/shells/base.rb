module KspMod::Shell
  class Base

    # Detect the proper subclass for this system
    def new_for_system
      shell_class = determine_ksp_shell
    end

    def determine_ksp_shell
      Kernel.require( './lib/shells/sh' )
      shell = KspMod::Shell::Sh
    end

    # Provided by native ruby
    def mv( source, dest )
    end

    # Provided by native ruby
    def cp( source, dest )
    end

    # Provided by native ruby
    def mkdir( dir )
    end

    def download( )
    end

    def unzip( file )
      raise NotImplementedError, "#{self.class.to_s} cannot unzip.  You need subclass such as KspMod::Shell::Sh"
    end

    def git
      raise NotImplementedError, "#{self.class.to_s} cannot call git.  You need subclass such as KspMod::Shell::Sh"
    end
  end
end
