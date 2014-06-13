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

    def exists?( path )
      return File.exists?( path )
    end

    # Provided by native ruby
    def cp( source, dest )
      if @dryrun
        log.info( "DRYRUN" ) { "Recursive copy: #{source} -> #{dest}" }
        return
      end

      unless File.exists?( source )
        warn "Could not find `#{source}`.  Did you mean `stage` instead of `install`?"
        exit 1
      end

      log.debug( "SHELL" ) { "Recursive copy of #{source} -> #{dest}" }
      FileUtils.copy_entry( source, dest, false, false, false )
    end

    def download( source, dest )
      if @dryrun
        log.info( "DRYRUN" ) { "Shell would download #{source} to #{dest}"}
        return
      end

      log.debug( "SHELL" ) { "Opening `#{dest}` for writing" }
      File.open( dest, 'wb' ) do |f|
        log.debug( "SHELL" ) { "Downloading #{source}" }

        # TODO: Switch to net/http or curb/curl to do a streaming download
        raw_response = nil
        retries = 3
        begin
          raw_response = HTTParty.get( source ).parsed_response
        rescue URI::InvalidURIError => e
          raise e if retries == 0
          retries -= 1
          uri = e.message.gsub( / ?bad URI\(is not URI\?\): /, '' )
          uri = URI.escape( uri )
          source = uri
          retry
        end

        f.write raw_response

        log.debug( "SHELL" ) { "Wrote #{f.pos / 1024} KB to `#{dest}`"}
      end
    end

    # Provided by native ruby
    def mkdir( dir )
      if @dryrun
        log.info( "DRYRUN" ) { "Shell would create `#{dir}`" }
        return
      end

      log.debug( "SHELL" ) { "Creating `#{dir}`" }
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
