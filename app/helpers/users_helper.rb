module UsersHelper
  def user_link
    '/'+current_user.name
  end
end
