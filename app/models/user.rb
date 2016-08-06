class User < ApplicationRecord
  before_create :name_downcase 
  has_many :items
  has_many :pokemon

  def self.search(query)
    where("screen_name like ?", "%#{query}%")
  end

  private
    def name_downcase
      self.name = name.downcase
    end
end
