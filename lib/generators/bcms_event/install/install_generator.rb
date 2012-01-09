require 'cms/module_installation'

class BcmsEvent::InstallGenerator < Cms::ModuleInstallation
  add_migrations_directory_to_source_root __FILE__

  # Add migrations to be copied, by uncommenting the following file and editing as needed.
  copy_migration_file '20090504174621_create_events.rb'

  def add_seed_data_to_project
    copy_file "../bcms_event.seeds.rb", "db/bcms_event.seeds.rb"
    append_to_file "db/seeds.rb", "load File.expand_path('../bcms_event.seeds.rb', __FILE__)"
  end
end
