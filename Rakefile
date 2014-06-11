# coding: utf-8
require 'bundler/gem_tasks'
require 'rake/clean'
require 'rubocop/rake_task'

# Clobber should also clean up built packages
CLOBBER.include('pkg')

# Use bundler to install deps since rake won't
task :install_deps do
  Bundler.with_clean_env do
    sh 'bundle install --system'
  end
end

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:lint) do |t|
  t.patterns = ['bin/**/*.rb', 'lib/**/*.rb']
  t.fail_on_error = false
end

Rake::Task[:install].enhance [:install_deps]

task default: [:build]

desc 'Run tests and build if successful'
task all: [:lint, :build]
