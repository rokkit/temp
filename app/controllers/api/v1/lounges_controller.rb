class Api::V1::LoungesController < Api::V1::BaseController
  def index
    @lounges = Lounge.all
    render json: @lounges
  end
end
