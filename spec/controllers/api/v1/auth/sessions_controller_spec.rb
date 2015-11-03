require 'rails_helper'

RSpec.describe Api::V1::Auth::SessionsController, type: :controller do
  render_views
  describe 'session creation when user exists' do
    let!(:user) { FactoryGirl.create(:user) }
    describe 'when phone and password valid' do
      it 'should return a user' do
        post :create, phone: user.phone, password: 'password'
        expect(json_body[:id]).to eq user.id
      end
    end
    describe 'when phone and password are invalid' do
      it 'should return errors' do
        post :create, phone: user.phone, password: 'wrongpassword'
        expect(json_body[:errors]).to be_present
      end
    end
  end

  describe 'password recovery' do
    describe 'when user with phone exits' do
      let!(:user) { FactoryGirl.create(:user) }
      before do
        expect(SMSService).to receive(:send).and_return(true)
        post :forgot, phone: user.phone
      end
      it 'should send a new password to user' do
        expect(response.status).to eq(200)
      end
    end
    describe 'when user with phone not exits or phone is wrong' do
      let!(:user) { FactoryGirl.create(:user) }
      before do
        expect(SMSService).to_not receive(:send)
        post :forgot, phone: 'wrong phone'
      end
      it 'should send a new password to user' do
        expect(json_body[:status]).to eq 'error'
      end
    end
  end
end
