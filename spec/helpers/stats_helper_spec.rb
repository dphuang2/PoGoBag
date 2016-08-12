require 'rails_helper'

RSpec.describe StatsHelper, type: :helper do
  describe '#rank_image(rank)' do
    it 'returns the correct image when rank is 1' do
      regex = %r{\/assets\/etc\/badge_lv3-\w*.png}
      expect(helper.rank_image('1')).to match regex
      expect(helper.rank_image(1)).to match regex
    end

    it 'returns the correct image when rank is 2' do
      regex = %r{\/assets\/etc\/badge_lv2-\w*.png}
      expect(helper.rank_image('2')).to match regex
      expect(helper.rank_image(2)).to match regex
    end

    it 'returns the correct image when rank is 3' do
      regex = %r{\/assets\/etc\/badge_lv1-\w*.png}
      expect(helper.rank_image('3')).to match regex
      expect(helper.rank_image(3)).to match regex
    end

    it 'returns nothing when rank is not in the allowed list' do
      expect(helper.rank_image('6')).to eq nil
      expect(helper.rank_image(nil)).to eq nil
      expect(helper.rank_image(12)).to eq nil
      expect(helper.rank_image('moocow')).to eq nil
    end
  end

  describe '#format_move(move)' do
    context 'when move is nil' do
      it 'returns an empty string' do
        expect(helper.format_move(nil)).to eq ''
      end
    end

    context 'when move contains _FAST' do
      it 'returns a capitalised move' do
        move = 'LOW_KICK_FAST'
        expect(helper.format_move(move)).to eq 'Low Kick'
      end
    end

    context 'when move does not contain _FAST' do
      it 'returns a capitalised move' do
        move = 'POWER_WHIP'
        expect(helper.format_move(move)).to eq 'Power Whip'
      end
    end
  end
end
