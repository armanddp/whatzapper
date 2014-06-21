require "whatzapper/version"
require "whatzapper/zapper"

module Whatzapper
  def self.zap
    zapper = Whatzapper::Zapper.new("/Volumes/Armand's iPhone Documents/ChatStorage.sqlite")
  end
end
