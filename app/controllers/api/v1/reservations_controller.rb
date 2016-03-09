class Api::V1::ReservationsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!
  def index
    @reservations = current_user.reservations.active.includes(table: :lounge).order(id: :desc).where('reservations.visit_date >= ?', Time.zone.now)
    respond_with @reservations
  end

  def create
	if current_user.freezed
		render json: { errors: { error: 'Can\'t create a reservation due to user being frozen.' } }
		return false
	end

    if !params[:lounge].present?
      render json: { errors: { lounge: 'not_found' } }
      return false
    end
    if !params[:visit_date].present? || params[:visit_date] == 'undefined' || params[:visit_date].include?('null')
      render json: { errors: { visit_date: 'wrong_date' } }
      return false
    end
    visit_date = Time.zone.strptime(params[:visit_date], "%d.%m.%Y %H:%M")

    if visit_date < Time.zone.now + 50.minutes
      render json: { errors: { visit_date: 'too_late' } }
      return false
    end

    end_visit_date = nil
    if current_user.role == 'vip'
      end_visit_date = visit_date + 2.hours + 30.minutes
    else
      end_visit_date = visit_date + 1.hours + 30.minutes
    end
    #
    if Reservation.active.where(user_id: current_user.id).where('end_visit_date > ? AND visit_date < ?', visit_date.utc, end_visit_date.utc).present?
      render json: { errors: { visit_date: 'wrong_date_one_client' } }
      return
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
    duration = nil
    if current_user.role == 'vip'
      duration = 2.5
    else
      duration = 1.5
    end
    @reservation = Reservation.new user: current_user,
                                   visit_date: visit_date,
                                   table: table,
                                   client_count: params[:client_count],
                                   duration: duration
    meets = []
    if params[:meets].present?

      # Если приглашает самого себя, то дать ачивку
      if params[:meets].include?(current_user.id.to_s)
        if params[:meets].length == 1
          achievement = Achievement.find_by_key('naedine-s-soboy')
          if !achievement
            achievement = Achievement.create(name: 'Наедине с собой', role: 'user')
          end
          if !AchievementsUser.where(user_id: current_user.id, achievement_id: achievement.id).present?
              AchievementsUser.create!(user: current_user, achievement: achievement)
          end
        else
          params[:meets].delete_if {|m| m == current_user.id }
        end
      end
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
    @meets = Meet.active.where(user_id: current_user.id).joins(:reservation).includes(:reservation).where('reservations.visit_date > ?', Time.zone.now)
  end


end
