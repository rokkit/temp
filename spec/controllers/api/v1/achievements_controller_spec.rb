require 'rails_helper'

RSpec.describe Api::V1::AchievementsController, type: :controller do
 render_views
 describe '#index' do
   let!(:achievement) { FactoryGirl.create :achievement }
   let!(:user) { FactoryGirl.create :user }
   before do
     @request.env['devise.mapping'] = Devise.mappings[:user]
     sign_in user
     get :index, format: :json
   end
   it 'returns list of total achievements with format' do
     expect(json_body).to eq [{id: achievement.id, name: achievement.name, description: achievement.description}]
   end
 end
end
