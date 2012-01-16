# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bcms_event/version"

Gem::Specification.new do |spec| 
  spec.name = "bcms_event"
  spec.rubyforge_project = spec.name
  spec.version = BcmsEvent::VERSION
  spec.summary = "The Event Module for BrowserCMS"
  spec.author = "BrowserMedia"
  spec.email = "github@browsermedia.com"
  spec.homepage = "http://www.github.com/browsermedia/bcms_event"
  spec.files += Dir["app/**/*"]
  spec.files += Dir["db/migrate/[0-9]*_create_events.rb"]
  spec.files += Dir["db/bcms_event.seeds.rb"]
  spec.files += Dir["lib/**/*"] 
  spec.files += Dir["Gemfile", "LICENSE.txt", "COPYRIGHT.txt", "GPL.txt" ]
  spec.files -= Dir['config/**/*', 
                    'public/**/*', 
                    'config.ru', 
                    'script/**/*',
                    'app/controllers/application_controller.rb',
                    'app/helpers/application_helper.rb',
                    'app/layouts/templates/**/*']
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = ["README.markdown" ]
  spec.add_dependency(%q<browsercms>, ["~> 3.3.0"])
end
