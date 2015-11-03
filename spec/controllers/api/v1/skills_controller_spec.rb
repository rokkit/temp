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
end
