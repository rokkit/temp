class Api::V1::ReservationsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!
  def index
    @reservations = current_user.reservations.active.includes(table: :lounge)
    respond_with @reservations
  end

  def create
    if !params[:lounge].present?
      render json: { errors: { lounge: 'not_found' } }
      return false
    end
    if !params[:visit_date].present? && params[:visit_date] == 'undefined'
      render json: { errors: { visit_date: 'wrong_date' } }
      return false
    end
    visit_date = Time.zone.strptime(params[:visit_date], "%Y-%m-%d %H:%M")

    if visit_date < Time.zone.now + 50.minutes
      render json: { errors: { visit_date: 'too_late' } }
      return false
    end
    #
    if Reservation.active.where(user_id: current_user.id).where('visit_date > ? AND visit_date < ?', visit_date.beginning_of_day, visit_date.end_of_day).present?
      render json: { errors: { visit_date: 'wrong_date' } }
      return
    end

    end_visit_date = nil
    if current_user.role == 'vip'
      end_visit_date = visit_date + 2.hours + 30.minutes
    else
      end_visit_date = visit_date + 1.hours + 30.minutes
    end


    reservations = Reservation.active.where('end_visit_date > ? AND visit_date < ? ',
                                    visit_date.utc, end_visit_date.utc)
    tables = []
    if current_user.role == 'vip'
      tables = Table.where(lounge_id: params[:lounge]).to_a
    else
      tables = Table.where(lounge_id: params[:lounge]).where(vip: nil).to_a
    end

    table = nil
    if reservations.length > 0
      reserved_tables = reservations.map(&:table)
      tables.reject! { |x| reserved_tables.include?(x) }
      if tables.length == 0
        render json: { errors: { visit_date: 'reserved' } }
        return false
      else
        table = tables.first
      end
    else
      table = tables.first
    end

    if table.nil?
      render json: { errors: { table: 'not_found' } }
      return
    end


    @reservation = Reservation.new user: current_user,
                                   visit_date: visit_date,
                                   table: table,
                                   client_count: params[:client_count]
    meets = []
    if params[:meets].present?
      params[:meets].each do |user_id|
        user = User.find(user_id)
        if user.level <= current_user.level
          meets.push Meet.new(user: user)
        end
      end
    end
    if @reservation.save!
      meets.each { |m| m.reservation = @reservation; m.save }
      render json: @reservation
    else
      render json: { errors: @reservation.errors }
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.user == current_user
      Meet.where(reservation_id: @reservation.id).each do |meet|
        meet.status = :deleted
        meet.save
      end
      @reservation.status = :deleted
      @reservation.save
    end
    head :ok
  end

  def load_data
    @users = User.where.not(id: current_user.id)
    @lounges = Lounge.where(active: true).includes(:tables)
    @payments = current_user.payments
    @meets = Meet.active.where(user_id: current_user.id).includes(:reservation).where('reservation.visit_date > ?', Time.zone.now)
  end


end
