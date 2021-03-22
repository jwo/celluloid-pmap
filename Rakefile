require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'
require 'rspec/core/rake_task'

# a little hack for RSpec::Core::RakeTask
::Rake.application.class.class_eval do
  alias_method :last_comment, :last_description
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--backtrace '] if ENV['DEBUG']
  spec.verbose = true
end

desc 'Default: run the unit tests.'
task default: [:all]

desc 'Test the plugin under all supported Celluloid versions.'
task :all do |_t|
  if ENV['TRAVIS']
    # require 'json'
    # puts JSON.pretty_generate(ENV.to_hash)
    if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
      appraisal_name = ENV['BUNDLE_GEMFILE'].scan(/celluloid\_(.*)\.gemfile/).flatten.first
      command_prefix = "appraisal celluloid-#{appraisal_name}"
      exec ("#{command_prefix} bundle install && #{command_prefix} bundle exec rspec")
    else
      exec(' bundle exec appraisal install && bundle exec rake appraisal spec')
    end
  else
    exec('bundle exec appraisal install && bundle exec rake appraisal spec')
  end
end
