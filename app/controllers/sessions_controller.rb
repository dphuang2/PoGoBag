class SessionsController < ApplicationController
  rescue_from Poke::API::Errors::LoginFailure, :with => :login_error

  def new
  end

  def create
    Poke::API::Logging.log_level = :DEBUG
    # Grab all credentials from form
    username = params[:user][:username]
    pass = params[:user][:password]
    auth = params[:user][:auth]

    # Log client in 
    client = Poke::API::Client.new
    client.login(username, pass, auth)

    # Create new user if user is new, otherwise retrieve it
    name = get_name(client)
    if User.exists?(:name => name)
      logger.debug "User exists"
      @user = User.find_by(name: name)
    else 
      logger.debug "New User"
      @user = User.create(name: name)
    end

    # set session variable
    session[:pogo_alias] = name
    #session[:user][:username] = username
    #session[:user][:pass] = pass
    #session[:user][:auth] = auth
    session[:user] = {username: username, password: pass, provider: auth}

    # Make requests until success (to deal with inconsistent response)
    while store_inventory(client, @user) == false
      store_inventory(client, @user)
    end
    flash[:success] = 'You logged in! Share your link with others: pogobag.me/users/'+name
    redirect_to user_link
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
end
