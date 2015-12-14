require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationsController, type: :controller do
  render_views
  describe '#create' do
    context 'with valid params' do
      let(:user) { FactoryGirl.attributes_for(:user_credentials) }
      before do
        expect(SMSService).to receive(:send).and_return(true)
        expect(SoapService).to receive(:call).and_return(true)
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
      let(:user) { FactoryGirl.create(:user_with_code,
        avatar: Rack::Test::UploadedFile.new(
                  File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg')
                )
        )
      }
      it 'confirm user if token valid' do
        post :confirm, code: user.phone_token, format: :json
        user.reload
        expect(user.confirmed_at).to be_present
      end
      context 'when code is invalid' do
        it 'returns error' do
          post :confirm, code: 'wrongcode'
          expect(json_body[:status]).to eq 'error'
        end
      end
      it 'returns user object' do
        post :confirm, code: user.phone_token, format: :json
        user.reload
        expect(json_body[:id]).to eq(user.id)
        expect(json_body[:auth_token]).to eq(user.auth_token)
        expect(json_body[:avatar]).to eq(user.avatar_url)
      end
    end
  end
end
