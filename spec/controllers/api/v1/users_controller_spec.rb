require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  render_views

  describe '#update' do
    let!(:user) { FactoryGirl.create :user, avatar: nil }
    let!(:achievement) { FactoryGirl.create :achievement, key: 'open_profile' }
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
          put :update, id: user.id, user: {name: 'New Name',email: 'user@exmaple.com', avatar: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'gerb_spb_liberty.svg'))}, format: :json
          user.reload
          expect(user.achievements.first).to eq achievement
          expect(json_body[:achievements]).to eq [{id: achievement.id, name: achievement.name}]
        end
      end
    end
  end
end
