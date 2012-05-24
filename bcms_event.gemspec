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
  
  spec.files = Dir["{app,config,db,lib}/**/*"]
  spec.files += Dir["Gemfile", "LICENSE.txt", "COPYRIGHT.txt", "GPL.txt" ]
  spec.test_files += Dir["test/**/*"]
  spec.test_files -= Dir['test/dummy/**/*']
  spec.add_dependency("browsercms", "< 3.6.0", ">= 3.5.0.rc3")
  
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = ["README.markdown" ]
end
