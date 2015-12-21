require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationsController, type: :controller do
  render_views
  before do
     allow_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
  end
  describe '#create' do
    context 'with valid params' do
      let(:user) { FactoryGirl.attributes_for(:user_credentials) }
      before do
        expect(SMSService).to receive(:send).and_return(true)

        post :create, user, format: :json
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
        post :create, user, format: :json
      end
      it 'not create a user without phone' do
        expect(json_body[:id]).to be_nil
      end
      it 'return errors array' do
        expect_json_types(errors: :object)
      end
    end

    describe 'phone confirmation with code' do

      context 'when code is invalid' do
        let!(:user) { FactoryGirl.create(:user_with_code) }
        it 'returns error' do
          expect(SoapService).to_not receive(:call)
          post :confirm, code: 'wrongcode'
          expect(json_body[:status]).to eq 'error'
        end
      end
      context 'when user already confirmed' do
        let!(:user) { FactoryGirl.create(:user_with_code) }
        it 'returns error' do
          expect(SoapService).to_not receive(:call)
          user.update_attribute :confirmed_at, DateTime.now
          post :confirm, code: user.phone_token, format: :json
          expect(json_body[:status]).to eq 'error'
        end
      end
      context 'when user not  confirmed' do
        let!(:user) { User.create!(phone: '1234', password: 'pass', phone_token: '1234') }
        before do
          # expect(SoapService).to receive(:call)
        end
        it 'returns user object' do
          post :confirm, code: user.phone_token, format: :json
          user.reload
          expect(json_body[:id]).to eq(user.id)
          expect(json_body[:auth_token]).to eq(user.auth_token)
          expect(json_body[:avatar]).to eq(user.avatar_url)
        end
        it 'confirm user if token valid' do
          post :confirm, code: user.phone_token, format: :json
          user.reload
          expect(user.confirmed_at).to be_present
        end
      end
    end
  end
end
