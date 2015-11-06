require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :controller do
  render_views
  describe '#index' do
    let!(:skill) { FactoryGirl.create :skill }
    let!(:skill2) { FactoryGirl.create :skill, parent: skill }
    let(:user) { FactoryGirl.create :user, skills: [skill] }
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
      get :index, format: :json
    end

    it 'returns list of skills' do
      expect_json_types(:array)
      expect(json_body.map { |l| l[:id] }).to eq [skill.id, skill2.id]
    end
    it 'returns list with image urls' do
      expect(json_body[0][:image]).to eq skill.image_url
    end
    it 'have a parent id' do
      expect(json_body[1][:parent_id]).to eq skill2.parent_id
    end
  end
  describe '#take' do
    context 'when user can do it' do
      let!(:skill) { FactoryGirl.create :skill }
      let!(:user) { FactoryGirl.create :user, skill_point: 1 }
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
        post :take, id: skill.id, format: :json
      end
      it 'add choosen skill to user' do
        expect(response).to be_success
        expect(json_body[:status]).to eq 'ok'
      end
      it 'substracts from user 1 skill point' do
        user.reload
        expect(user.skill_point).to eq(0)
      end
    end

    context 'when the conditions is wrong' do
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
  end
end
