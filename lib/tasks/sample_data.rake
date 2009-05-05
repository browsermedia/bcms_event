desc "Load Sample Data"
task :load_sample_data => :environment do
  SampleData.create_sample_data!
end