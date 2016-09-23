class Item < ApplicationRecord
  belongs_to :user, dependent: :destroy
  validates :item_id, presence: true
  validates :count, presence: true
end
