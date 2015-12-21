class Api::V1::LoungesController < Api::V1::BaseController
  respond_to :json
  def index
    @lounges = Lounge.all.order(:order_number)
    respond_with @lounges
  end

  def show
    @lounge = Lounge.find(params[:id])
    respond_with @lounge
  end
end
