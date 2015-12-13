Dir.glob('./{models,helpers,controllers}/*.rb').each { |file| require file }
require 'sinatra/activerecord/rake'
require 'rake/testtask'

task :default => [:spec]

desc 'Run specs'
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