require "bundler/gem_tasks"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:specs)

task default: :spec

task :spec do
  Rake::Task["specs"].invoke
end
