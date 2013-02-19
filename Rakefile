# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "catcher"
  gem.homepage = "http://github.com/onthebeach/catcher"
  gem.license = "MIT"
  gem.summary = %Q{Automatic caching for API calls}
  gem.description = %Q{Catcher wraps JSON API calls, and stores the parsed hash in Memcached. Subsequent calls to the same API will either be returned directly from cache, or drop through to the API.}
  gem.email = "seenmyfate@gmail.com"
  gem.authors = ["seenmyfate"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  ENV['COVERAGE'] = 'coverage'
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
