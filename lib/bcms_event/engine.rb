require 'browsercms'

module BcmsEvent
  class Engine < Rails::Engine
    include Cms::Module
    isolate_namespace BcmsEvent
  end
end