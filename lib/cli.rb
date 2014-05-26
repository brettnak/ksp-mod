class KspMod::Cli
  def initialize
  end

  def list
  end

  def install
  end

  def uninstall
  end

  # Entry point after creating a new CLI
  def main
    ap KspMod.config
    command = ARGV.shift
  end
end
