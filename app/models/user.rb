class User < ApplicationRecord
  before_create :name_downcase
  has_many :items
  has_many :pokemon

  scope :trainer_search, -> (name) {
    name.present? ? where('screen_name LIKE ?', "%#{name}%") : all
  }

  private

    def name_downcase
      self.name = name.downcase
    end
end
