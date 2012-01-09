require 'browsercms'

module BcmsEvent
  class Engine < Rails::Engine
    include Cms::Module
  end
end