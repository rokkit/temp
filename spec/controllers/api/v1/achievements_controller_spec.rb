require 'rails_helper'

RSpec.describe Api::V1::AchievementsController, type: :controller do
 render_views
 describe '#index' do
   let!(:achievement) { FactoryGirl.create :achievement }
   let!(:user) { FactoryGirl.create :user }
   before do
     @request.env['devise.mapping'] = Devise.mappings[:user]
     sign_in user
   end
   it 'returns list of total achievements' do
     get :index, format: :json
     expect(json_body).to eq [{
                               id: achievement.id,
                               name: achievement.name,
                               description: achievement.description,
                               image: achievement.image_url,
                               open: false
                              }]
   end

   context 'when user have unlocked achievements' do
     let!(:achievement) { FactoryGirl.create :achievement }
     let!(:user) { FactoryGirl.create :user }
     let!(:achievement_user) { AchievementsUser.create user: user, achievement: achievement }
     before do
       sign_in user
     end
     it 'returns list of total achievements with open status' do
       get :index, format: :json

       expect(json_body).to eq [{
                                 id: achievement.id,
                                 name: achievement.name,
                                 description: achievement.description,
                                 image: achievement.image_url,
                                 open: true
                                }]
     end
   end
 end
end
