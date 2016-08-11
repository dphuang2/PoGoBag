desc 'Update all user data with Google accounts'
task refresh_data: :environment do
  include SessionsHelper
  Poke::API::Logging.log_level = :WARN if Rails.env.production?
  Rails.logger.warn "Running rake task"
  @users = User.where.not('refresh_token' => nil)
  @users.each do |user|
    if user.access_token_expire_time > Time.now.to_i
      refresh_data(user)
    end
  end
end
