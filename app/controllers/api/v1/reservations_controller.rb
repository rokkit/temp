class Api::V1::ReservationsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!

  # создать бронирование на указанную дату для юзера
  def create
    table = Table.find(params[:table_id])
    visit_date = DateTime.parse(params[:visit_date])
    if table
      @reservation = Reservation.new user: current_user, table: table, visit_date: visit_date
      params[:meets].each do |user_id|
        user = User.find(user_id)
        if user
          @reservation.meets.push Meet.new user: user
        end
      end if params[:meets].present?
      if @reservation.save
        render json: @reservation
      else
        render json: { errors: @reservation.errors }
      end
    end
  end

  def load_data
    @users = User.where.not(id: current_user.id)
    @lounges = Lounge.all.includes(:tables)
    #code
  end
end
