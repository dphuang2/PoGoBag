class Pokemon < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
