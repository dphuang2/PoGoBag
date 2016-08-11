require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :items }
    it { is_expected.to have_many :pokemon }
  end

  describe 'scopes' do
    describe '.trainer_search' do
      let!(:first_user) { create :user, screen_name: 'FirstUser' }
      let!(:second_user) { create :user, screen_name: 'SecondUser' }
      let!(:bob) { create :user, screen_name: 'Bob' }

      it 'returns all matching records with a partial search' do
        expect(described_class.trainer_search('user')).to \
          match_array [first_user, second_user]
      end

      it 'only returns the first user' do
        expect(described_class.trainer_search('firstuser')).to \
          match_array [first_user]
      end

      it 'returns all records when search term is blank' do
        expect(described_class.trainer_search('')).to \
          match_array [first_user, second_user, bob]
      end
    end
  end

  describe 'callbacks' do
    it 'downcases the trainer name before saving' do
      subject.name = 'ALLCAPS'
      subject.save!
      subject.reload
      expect(subject.name).to eq 'allcaps'
    end
  end
end
