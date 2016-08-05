class User < ApplicationRecord
  include SessionsHelper

  before_create :name_downcase 
  has_many :items
  has_many :pokemon

  def scheduled_refresh
    logger.debug "Whenever is working"
    @users = User.where.not('refresh_token' => nil)
    @users.each do |user|
      if user.access_token_expire_time > Time.now.to_formatted_s(:number).to_f
        refresh_data(user)
      end
    end
  end

  private
    def name_downcase
      self.name = name.downcase
    end
end
