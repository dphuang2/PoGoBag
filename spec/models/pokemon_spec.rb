require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :poke_id }
    it { is_expected.to validate_presence_of :move_1 }
    it { is_expected.to validate_presence_of :move_2 }
    it { is_expected.to validate_presence_of :max_health }
    it { is_expected.to validate_presence_of :attack }
    it { is_expected.to validate_presence_of :defense }
    it { is_expected.to validate_presence_of :stamina }
    it { is_expected.to validate_presence_of :cp }
    it { is_expected.to validate_presence_of :iv }
    it { is_expected.to validate_presence_of :favorite }
    it { is_expected.to validate_presence_of :num_upgrades }
    it { is_expected.to validate_presence_of :battles_attacked }
    it { is_expected.to validate_presence_of :battles_defended }
    it { is_expected.to validate_presence_of :pokeball }
    it { is_expected.to validate_presence_of :height_m }
    it { is_expected.to validate_presence_of :weight_kg }
    it { is_expected.to validate_presence_of :health }
    it { is_expected.to validate_presence_of :poke_num }
    it { is_expected.to validate_presence_of :creation_time_ms }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end
end
