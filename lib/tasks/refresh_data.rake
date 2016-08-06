desc 'update all user data with google accounts'
task refresh_data: :environment do
  include SessionsHelper
  @users = User.where.not('refresh_token' => nil)
  puts @users
  @users.each do |user|
    if user.access_token_expire_time > Time.now.to_formatted_s(:number).to_f
      refresh_data(user)
    end
  end
end
