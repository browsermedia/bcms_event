namespace :db do
  namespace :seed do
    desc "Load the seed data from db/bcms_event.seeds.rb."
    task :bcms_event => :environment do
      require "#{Rails.root}/db/bcms_event.seeds.rb"
    end
  end
end