class SessionsController < ApplicationController
  Poke::API::Logging.log_level = :DEBUG if Rails.env.development?
  Poke::API::Logging.log_level = :WARN if Rails.env.production?
  rescue_from Poke::API::Errors::LoginFailure, :with => :login_error_ptc
  rescue_from ActionController::InvalidAuthenticityToken, :with => :logout_error
  rescue_from Poke::API::Errors::UnknownProtoFault, :with => :login_error_google

  def create
    # Authorize
    auth_objects = setup_user
    client = auth_objects[:client]
    @user = auth_objects[:user]
    # Store all data
    if store_data(client, @user) #SUCCESS
      # set session variable to log in
      session[:pogo_alias] = @user.name
      # Redirect
      redirect_to user_link
    else #FAIL
      flash[:danger] = "There was an error when requesting your data (This could be because your account is banned or Niantic's servers are busy). Please try again."
      redirect_to '/home'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  protected
    def login_error_ptc
      flash.now[:danger] = 'Invalid user/password combination'
      render 'static_pages/home'
    end
    def logout_error
      redirect_to 'static_pages/home'
    end
    def login_error_google
      flash.now[:danger] = 'Authorization code was empty'
      #flash.now[:danger] = 'Niantic is blocking requests from the server. Please stand by.'
      render 'static_pages/home'
    end
end
