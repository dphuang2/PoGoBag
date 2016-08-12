require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  let(:user) { build_stubbed :user }

  describe '#user_link' do
    it 'returns the path to a user' do
      expect(helper).to receive(:current_user).and_return(user)
      expect(helper.user_link).to eq "/#{user.name}"
    end
  end

  describe '#pokemon_image(number)' do
    it "returns a pokemon image for a given number" do
      expect(helper.pokemon_image(003)).to match %r{pokemon\/003 - \w*-\w*.png}
    end
  end
end
