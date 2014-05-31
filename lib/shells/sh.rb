# This class knows how to translate each of these standard unix
# commands into whatever shell the system uses into ruby native
# file management commands.  It may be unnecessary and could be
# moved into the base class.

class KspMod::Shell::Sh < KspMod::Shell::Base
  def initialize
    super
  end

  # TODO: raise error, don't fail silently if the archive was not unzipped.
  def unzip( zip_file, destdir )
    if @dryrun
      log.info( "DRYRUN" ) { "Unzip #{zip_file} to #{destdir}" }
      return
    end

    cmd = "unzip -u #{zip_file} -d #{destdir}"

    exit_value = nil

    log.debug( "SHELL-SH" ) { "Executing `#{cmd}` as subprocess" }
    Open3.popen3( cmd ) do |stdin, stdout, stderr, waiter|
      t_out = Thread.new do
        stdout.each_line do |line|
          log.debug( "SHELL-SH-OUT" ) { line.strip }
        end
      end

      t_err = Thread.new do
        stderr.each_line do |line|
          log.debug( "SHELL-SH-ERR" ) { line.strip }
        end
      end

      t_out.join
      t_err.join

      exit_value = waiter.value
    end

    log.debug( "SHELL-SH" ) { "`#{cmd}` exited with code #{exit_value.exitstatus}" }
  end

  def git
    raise NotImplementedError, "Not yet complete."
  end
end
