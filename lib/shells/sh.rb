# This class knows how to translate each of these standard unix
# commands into whatever shell the system uses into ruby native
# file management commands.  It may be unnecessary and could be
# moved into the base class.

class KspMod::Shell::Sh < KspMod::Shell::Base
  def initialize
    super
  end

  def unzip
  end

  def git
  end
end
