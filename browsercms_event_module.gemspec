SPEC = Gem::Specification.new do |spec| 
  spec.name = "browser_cms_event_module"
  spec.rubyforge_project = spec.name
  spec.version = "3.0.0"
  spec.summary = "The Event Module for BrowserCMS"
  spec.author = "BrowserMedia"
  spec.email = "github@browsermedia.com"
  spec.homepage = "http://www.browsercms.org"
  spec.files += Dir["app/controllers/cms/*"]
  spec.files += Dir["app/models/*"]
  spec.files += Dir["app/portlets/*"]
  spec.files += Dir["app/views/cms/**/*"]
  spec.files += Dir["app/views/portlets/**/*"]
  spec.files += Dir["db/migrate/[0-9]*_create_events.rb"]
  spec.files += Dir["lib/browser_cms_event_module.rb"]
  spec.files += Dir["lib/browser_cms_event_module/*"]  
  spec.files += Dir["rails/init.rb"]
  spec.has_rdoc = true
  spec.extra_rdoc_files = ["README"]
end
