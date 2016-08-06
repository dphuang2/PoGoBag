class User < ApplicationRecord
  include SessionsHelper

  before_create :name_downcase 
  has_many :items
  has_many :pokemon

  private
    def name_downcase
      self.name = name.downcase
    end
end
