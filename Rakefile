require 'rake/testtask'
require 'config_env/rake_tasks'

task :config do
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

desc "Echo to stdout an environment variable"
task :echo_env, [:var] => :config do |t, args|
  puts "#{args[:var]}: #{ENV[args[:var]]}"
end

desc 'Run all tests'
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

namespace :db do
  require_relative 'models/init.rb'
  require_relative 'config/init.rb'

  desc "Create groups table"
  task :migrate do
    begin
      Groups.create_table
      puts 'Groups table created'
    rescue Aws::DynamoDB::Errors::ResourceInUseException => e
      puts 'Groups table already exists'
    end
  end

  desc "Create products table"
  task :migrate do
    begin
      Products.create_table
      puts 'Products table created'
    rescue Aws::DynamoDB::Errors::ResourceInUseException => e
      puts 'Products table already exists'
    end
  end
end
