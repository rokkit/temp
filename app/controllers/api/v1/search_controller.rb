class Api::V1::SearchController < Api::V1::BaseController
  before_action :authenticate_user!
  respond_to :json

  def index
	if (params[:string])
		search = params[:string]
		@users = User.where("id != #{current_user.id} AND name ILIKE ?", "%#{search}%")
	else
		exit
	end
  end
end
