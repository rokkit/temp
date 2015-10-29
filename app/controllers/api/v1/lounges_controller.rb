class Api::V1::LoungesController < Api::V1::BaseController
  respond_to :json
  def index
    @lounges = Lounge.all

    respond_with @lounges
  end
end
