require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let!(:user) { create :user }

  describe '#current_user' do
    before do
      session[:pogo_alias] = user.name
    end

    it 'returns the current user' do
      expect(helper.current_user).to eq user
    end
  end

  describe '#logged_in' do
    it 'is false if we have no current user' do
      allow(helper).to receive(:current_user).and_return(nil)
      expect(helper.logged_in?).to be false
    end

    it 'is true if we have a current user' do
      allow(helper).to receive(:current_user).and_return(user)
      expect(helper.logged_in?).to be true
    end
  end

  describe '#log_out' do
    it 'deletes the session and resets the user object' do
      expect(session).to receive(:delete).with(:pogo_alias)
      expect(session).to receive(:delete).with(:user)
      expect(helper.log_out).to be nil
    end
  end

  describe '#destroy_user_data(user)' do
    it 'destroys data' do
      expect(user.items).to receive(:destroy_all).and_call_original
      expect(user.pokemon).to receive(:destroy_all).and_call_original

      helper.destroy_user_data(user)
    end
  end

  describe '#store_data(client, user)' do
  end

  describe '#get_player_info(client)' do
  end

  describe '#setup_user' do
  end

  describe '#setup_client_user_pair' do
  end

  describe '#refresh_data(user)' do
  end

  describe '#authorized_client(token, type=XXX)' do
  end

  describe '#get_call(client, req' do
  end
end
