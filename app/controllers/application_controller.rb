class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  require 'poke-api'
  include SessionsHelper
  include UsersHelper
end
