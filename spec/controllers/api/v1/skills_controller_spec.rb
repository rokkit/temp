require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :controller do
  render_views
  describe "current user skills" do
    let!(:skill) { FactoryGirl.create :skill }
    let!(:skill2) { FactoryGirl.create :skill, parent: skill }
    let(:user) { FactoryGirl.create :user, skills: [skill] }
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      get :index, format: :json
    end

    it "should return list of skills" do
      expect_json_types(:array)
      expect(json_body.map {|l| l[:id] }).to eq [skill.id, skill2.id]
    end
    it "should return list with image urls" do
      expect(json_body[0][:image]).to eq skill.image_url
    end
    it "should have a parent id" do
      expect(json_body[1][:parent_id]).to eq skill2.parent_id
    end
  end

  describe "skills operation" do
    describe "skill take" do
      describe "when user can do it" do
        let!(:skill) { FactoryGirl.create :skill }
        let!(:user) { FactoryGirl.create :user, skill_point: 1 }
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          sign_in user
          post :take, id: skill.id, format: :json
        end
        it "should add choosen skill to user" do
           expect(response).to be_success
           expect(json_body[:status]).to eq 'ok'
        end
        it "should substract from user 1 skill point" do
          user.reload
          expect(user.skill_point).to eq(0)
        end
      end

      describe "when the conditions is wrong" do
        let!(:skill) { FactoryGirl.create :skill }
        let!(:user) { FactoryGirl.create :user, skill_point: 0 }
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          sign_in user
          post :take, id: skill.id, format: :json
        end
        describe "when skill point is not enought" do
          it 'should fails with error' do
            expect(json_body[:status]).to eq 'error'
          end
        end

      end

    end
  end
end
