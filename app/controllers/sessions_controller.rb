class SessionsController < ApplicationController
  def new
  end

  def create
    # Grab all credentials from form
    user = params[:user][:username]
    pass = params[:user][:password]
    auth = params[:user][:auth]

    # Log client in 
    client = client = Poke::API::Client.new
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

end
