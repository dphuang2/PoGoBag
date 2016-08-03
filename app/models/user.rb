class User < ApplicationRecord
  before_create :name_downcase 
  has_many :items
  has_many :pokemon

  # Take data from Google and persist to database
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.access_token = auth.extra.id_token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  private
    def name_downcase
      self.name = name.downcase
    end
end
