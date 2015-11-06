require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationsController, type: :controller do
  render_views
  describe '#create' do
    context 'with valid params' do
      let(:user) { FactoryGirl.attributes_for(:user_credentials) }
      before do
        expect(SMSService).to receive(:send).and_return(true)
        post :create, user
      end
      it 'create a user with phone' do
        expect(json_body[:status]).to eq('ok')
      end
      it 'set a phone confirmation token' do
        expect(User.find_by_phone(user[:phone]).phone_token).to be_present
      end
    end
    context 'with invalid params' do
      let(:user) { FactoryGirl.attributes_for(:user_credentials, phone: nil) }
      before do
        expect(SMSService).to_not receive(:send)
        post :create, user
      end
      it 'not create a user without phone' do
        expect(json_body[:id]).to be_nil
      end
      it 'return errors array' do
        expect_json_types(errors: :object)
      end
    end

    describe 'phone confirmation with code' do
      let(:user) { FactoryGirl.create(:user_with_code) }
      it 'confirm user if token valid' do
        post :confirm, code: user.phone_token
        user.reload
        expect(user.confirmed_at).to be_present
        expect(json_body[:status]).to eq 'ok'
      end
      context 'when code is invalid' do
        it 'returns error' do
          post :confirm, code: 'wrongcode'
          expect(json_body[:status]).to eq 'error'
        end
      end
      it 'returns user object' do
        post :confirm, code: user.phone_token
        user.reload
        expect(json_body[:user][:id]).to eq(user.id)
      end
    end
  end
end
