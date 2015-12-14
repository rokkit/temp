require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  render_views

  describe '#update' do
    let!(:user) { FactoryGirl.create :user, avatar: nil }
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
    it "updates user profile" do
      put :update, id: user.id, user: {name: 'New Name', avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg'))}, format: :json
      user.reload
      expect(json_body[:avatar]).to eq user.avatar_url
    end
    describe '"Open Profile" achievement' do
      context 'when all profile attributes filled' do
        it 'add achievement to user' do
          put :update, id: user.id,
            name: 'New Name',
            avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg')),
            hobby: 'Hobby',
            employe: 'employe',
            work_company: 'work',
            city: 'City17',
            format: :json
          user.reload
          expect(user.achievements.first).to eq Achievement.first
          expect(json_body[:achievements]).to eq [{id: Achievement.first.id, name: Achievement.first.name}]
        end
      end
    end
  end

  describe '#show' do
    let!(:user) { FactoryGirl.create :user }
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end
    it 'return experience of user' do
      get :show, id: user.id, format: :json
      expect(json_body[:exp]).to be_present
    end
    it 'returns visits of user' do
      get :show, id: user.id, format: :json
      expect(json_body[:visits]).to_not be_nil
    end
  end
end
