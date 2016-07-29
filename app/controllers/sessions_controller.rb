class SessionsController < ApplicationController
  rescue_from Poke::API::Errors::LoginFailure, :with => :login_error
  rescue_from NoMethodError, :with => :missing_auth

  def new
  end

  def create

    # Grab all credentials from form
    user = params[:user][:username]
    pass = params[:user][:password]
    auth = params[:user][:auth]

    # Log client in 
    client = Poke::API::Client.new
    client.login(user, pass, auth)

    # Create new user if user is new, otherwise retrieve it
    name = get_name(client)
    if user = user_exist?(name)
      user
    else 
      user = User.create(name: name)
    end

    store_inventory(client, user)

    # set session variable
    session[:pogo_alias] = name
    redirect_to user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  protected
    def login_error
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end

    def missing_auth
      flash.now[:danger] = 'Select an authorization method (PTC or Google)'
      render 'new'
    end

      
end
