class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'poke-api'
  include SessionsHelper
end
