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
    pending 'needs refactor'
  end

  describe '#get_player_info(client)' do
    pending 'needs refactor'
  end

  describe '#setup_user' do
    pending 'needs refactor'
  end

  describe '#setup_client_user_pair' do
    pending 'needs refactor'
  end

  describe '#refresh_data(user)' do
    pending 'needs refactor'
  end

  describe '#authorized_client(token, type=XXX)' do
    pending 'needs refactor'
  end

  describe '#get_call(client, req)' do
    let(:client) { double 'client' }
    let(:req) { double 'request' }

    before do
      allow(client).to receive(:send).with(req).and_return(client)
    end

    it 'runs "call" on client' do
      expect(client).to receive(:call)
      helper.get_call(client, req)
    end
  end
end
