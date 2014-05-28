module KspMod::Loggable
  def log
    return KspMod.logger
  end

  def self.log
    return KspMod.logger
  end

  def KspMod.included( base )
    base.__send__( :extend, KspMod::Loggable )
  end
end
