# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

BcmsEvent::Application.load_tasks

require 'bundler'
Bundler::GemHelper.install_tasks

desc "Load Sample Data"
task :load_sample_data => :environment do
  SampleData.create_sample_data!
end