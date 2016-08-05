require 'capistrano/setup'
require 'capistrano/deploy'
require 'whenever/capistrano'
 set :whenever_command, "bundle exec whenever"
 set :whenever_environment, defer { stage }
require "whenever/capistrano"
require 'capistrano/rails/collection'
require 'capistrano/rvm'
 set :rvm_type, :user
 set :rvm_ruby_version, '2.3.1'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/passenger'

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

