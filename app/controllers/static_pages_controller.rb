class StaticPagesController < ApplicationController
  def home
    if logged_in?
      redirect_to '/users/'+current_user.name
    end
  end

  def about
  end

  def contact
  end
end
