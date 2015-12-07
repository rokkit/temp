require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :controller do
  render_views
  describe '#index' do
    let!(:skill) { FactoryGirl.create :skill }
    let!(:skill2) { FactoryGirl.create :skill }
    let(:user) { FactoryGirl.create :user, skills: [skill] }
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    it 'returns list of skills' do
      get :index, role: 'user', format: :json
      expect(json_body.map { |l| l[:id] }).to eq [skill.id, skill2.id]
    end
    it 'returns list of skills with parent structure' do
      SkillsLink.create parent: skill, child: skill2
      get :index, role: 'user', format: :json
      expect(json_body[1][:parents]).to eq [skill.id]
    end
    it 'returns list with image urls' do
      get :index, role: 'user', format: :json
      expect(json_body[0][:image]).to eq skill.image_url
    end
  end
  describe '#take' do
    context 'when user can do it' do
      let!(:skill) { FactoryGirl.create :skill, cost: 2 }
      let!(:user) { FactoryGirl.create :user, skill_point: 3 }
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
      end
      it 'add choosen skill to user' do
        post :take, id: skill.id, format: :json
        expect(response).to be_success
        expect(json_body[:status]).to eq 'ok'
      end
      it 'substracts from user the required number of skill point' do
        current_exp_points = user.skill_point
        expect { post :take, id: skill.id, format: :json }
        .to change { User.find(user.id).skill_point }.from(current_exp_points).to(current_exp_points - skill.cost)
      end

      it 'отмечает навык взятым в списке навыков' do
        current_exp_points = user.skill_point
        post :take, id: skill.id, format: :json
        get :index, role: 'user', format: :json
        expect(json_body[0][:has]).to eq true
      end
    end
    describe '#use' do
      describe "клиент может использовать навык" do
        let!(:skill) { FactoryGirl.create :skill }
        let!(:user) { FactoryGirl.create :user, skills: [skill] }
        before do
          sign_in user
        end
        it "указывает дату использования" do
          post :use, id: skill.id, format: :json
          expect(json_body[:status]).to eq 'ok'
        end
        it "указывает дату использования у связи навык-юзер" do
          expect {
            post :use, id: skill.id, format: :json
          }.to change { SkillsUsers.first.used_at }
        end
      end
    end

    context 'when the conditions is wrong' do
      context 'when user not have points' do
        let!(:skill) { FactoryGirl.create :skill }
        let!(:user) { FactoryGirl.create :user, skill_point: 0 }
        before do
          @request.env['devise.mapping'] = Devise.mappings[:user]
          sign_in user
          post :take, id: skill.id, format: :json
        end
        context 'when skill point is not enought' do
          it 'fails with error' do
            expect(json_body[:status]).to eq 'error'
          end
        end
      end
      context 'when user try to take cost with greater than he has points' do
        let!(:skill) { FactoryGirl.create :skill, cost: 2 }
        let!(:user) { FactoryGirl.create :user, skill_point: 1 }
        before do
          @request.env['devise.mapping'] = Devise.mappings[:user]
          sign_in user
          post :take, id: skill.id, format: :json
        end
        context 'when skill point is not enought' do
          it 'fails with error' do
            expect(json_body[:status]).to eq 'error'
          end
        end
      end
    end
  end
end
