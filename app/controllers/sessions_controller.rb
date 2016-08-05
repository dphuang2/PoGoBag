class SessionsController < ApplicationController
  rescue_from Poke::API::Errors::LoginFailure, :with => :login_error_ptc
  rescue_from ActionController::InvalidAuthenticityToken, :with => :logout_error
  rescue_from Poke::API::Errors::UnknownProtoFault, :with => :login_error_google

  def create
    Poke::API::Logging.log_level = :DEBUG

    # Log client in 
    client = Poke::API::Client.new
    client = setup_client(client)
    # Save name to ActiveRecord
    screen_name = get_name(client)
    name = screen_name.downcase
    @user = User.where(:name => name).first_or_create!
    @user.screen_name = screen_name
    @user.save
    # set session variable to log in
    session[:pogo_alias] = name
    # Store all data
    destroy_user_data(@user)
    store_data(client, @user)
    flash[:success] = "You logged in! Share your link with others: http://pogobag.me/"+name
    redirect_to user_link
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
      render 'static_pages/home'
    end
end
