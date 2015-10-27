require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationsController, type: :controller do
  describe 'registration with valid params' do
    let(:user) { FactoryGirl.attributes_for(:user_credentials) }
    before do
      expect(SMSService).to receive(:send).and_return(true)
      post :create, user
    end
    it 'create a user with phone' do
      expect_json_types(id: :integer)
    end
    it 'should set a phone confirmation token' do
      expect(User.find(json_body[:id]).phone_token).to be_present
    end
  end
  describe 'registration with invalid params' do
    let(:user) { FactoryGirl.attributes_for(:user_credentials, phone: nil) }
    before do
      expect(SMSService).to_not receive(:send)
      post :create, user
    end
    it 'not create a user without phone' do
      expect(json_body[:id]).to be_nil
    end
    it 'should return errors array' do
      expect_json_types(errors: :object)
    end
  end

  describe 'phone confirmation with code' do
    let(:user) { FactoryGirl.create(:user_with_code) }
    it 'should confirm user if token valid' do
      post :confirm, code: user.phone_token
      user.reload
      expect(user.confirmed_at).to be_present
      expect(json_body[:status]).to eq 'ok'
    end
    it 'should return error when code is invalid' do
      post :confirm, code: 'wrongcode'
      expect(json_body[:status]).to eq 'error'
    end
  end
end
