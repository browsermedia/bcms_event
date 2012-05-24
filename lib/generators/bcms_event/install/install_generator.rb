require 'cms/module_installation'

class BcmsEvent::InstallGenerator < Cms::ModuleInstallation

  def copy_migrations
    rake 'bcms_event:install:migrations'
  end

  def add_seed_data_to_project
    copy_file "../bcms_event.seeds.rb", "db/bcms_event.seeds.rb"
    append_to_file "db/seeds.rb", "load File.expand_path('../bcms_event.seeds.rb', __FILE__)"
  end
  
  def add_routes
    mount_engine(BcmsEvent)
  end
  
end
