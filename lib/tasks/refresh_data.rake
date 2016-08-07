desc 'update all user data with google accounts'
task refresh_data: :environment do
  include SessionsHelper
  Poke::API::Logging.log_level = :WARN if Rails.env.production?
  @users = User.where.not('refresh_token' => nil)
  @users.each do |user|
    if user.access_token_expire_time > Time.now.to_i
      logger.warn user.screen_name
      refresh_data(user)
    end
  end
end
