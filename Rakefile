require 'rake/testtask'
require 'sinatra/activerecord/rake'

task :default => [:spec]

desc 'Run specs'
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end
