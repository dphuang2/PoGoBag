class Pokemon < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :poke_id, presence: true
  validates :move_1, presence: true
  validates :move_2, presence: true
  validates :max_health, presence: true
  validates :attack, presence: true
  validates :defense, presence: true
  validates :stamina, presence: true
  validates :cp, presence: true
  validates :iv, presence: true
  validates :favorite, presence: true
  validates :num_upgrades, presence: true
  validates :battles_attacked, presence: true
  validates :battles_defended, presence: true
  validates :pokeball, presence: true
  validates :height_m, presence: true
  validates :weight_kg, presence: true
  validates :health, presence: true
  validates :poke_num, presence: true
  validates :creation_time_ms, presence: true
end
