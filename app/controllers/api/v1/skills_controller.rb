class Api::V1::SkillsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!
  def index
    @skills = Skill.all.order(:id)
    respond_with @skills
  end
end
