require 'rails_helper'

RSpec.describe Api::V1::AchievementsController, type: :controller do
 render_views
 before do
    allow_any_instance_of(User).to receive(:create_user_ext).and_return('1234')
 end
 describe '#index' do
   let!(:achievement) { FactoryGirl.create :achievement }
   let!(:user) { FactoryGirl.create :user }
   before do
     sign_in user
   end
   it 'returns list of total achievements' do
     get :index, role: user.role, format: :json
     expect(json_body).to eq [{
                               id: achievement.id,
                               name: achievement.name,
                               description: achievement.description,
                               image: achievement.image_url,
                               open: false,
                               viewed: false
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
                                 open: true,
                                 viewed: false
                                }]
     end
   end
 end

 describe "#viewed" do
   let!(:achievement) { FactoryGirl.create :achievement }
   let!(:user) { FactoryGirl.create :user }
   let!(:achievement_user) { AchievementsUser.create user: user, achievement: achievement }
   before do
     sign_in user
   end
   it "обновляет связь ачивка-юзер" do
      expect {
        post :viewed, id: achievement.id, format: :json
        achievement_user.reload
      }.to change {
        achievement_user.viewed
      }.from(false).to(true)
   end
 end
end
