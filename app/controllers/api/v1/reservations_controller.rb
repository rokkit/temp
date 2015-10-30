class Api::V1::ReservationsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!

  # создать бронирование на указанную дату для юзера
  def create
    table = Table.find(params[:table_id])
    visit_date = DateTime.parse(params[:visit_date])
    if table
      @reservation = Reservation.new user: current_user, table: table, visit_date: visit_date
      if @reservation.save
        render json: @reservation
      else
        render json: {errors: @reservation.errors }
      end
    end
  end
end
