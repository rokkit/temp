class Api::V1::ReservationsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!
  def index
    @reservations = current_user.reservations
    respond_with @reservations
  end
  # создать бронирование на указанную дату для юзера
  # def create
  #   puts "---------------- #{DateTime.parse(params[:visit_date]).strftime('%Y-%m-%d %R:00')}"
  #
  #   visit_date = DateTime.parse(params[:visit_date])
  #   if visit_date < DateTime.now + 50.minutes
  #     render json: { errors: { visit_date: 'too_late' } }
  #     return false
  #   end
  #
  #   before_visit_date = (visit_date-3.hours).strftime('%Y-%m-%d %R:00')
  #   after_visit_date = (visit_date + 3.hours).strftime('%Y-%m-%d %R:00')
  #   table_reservations_ext = ExtService.execute "SELECT _document74.* FROM _document74 \
  #   WHERE (_fld1047 >= '#{before_visit_date}' \
  #      AND _fld1047 < '#{after_visit_date}') ORDER BY _fld1047"
  #   puts "reservations: " + table_reservations_ext.map {|t| [t['_fld1047'], t['_fld1049rref']] }.inspect
  #   reserved_tables = ExtService.execute("SELECT _reference27.* FROM _reference27 LEFT JOIN _document74 \
  #   ON _reference27._idrref = _document74._fld1049rref \
  #   WHERE _document74._idrref IS NULL \
  #     AND _document74._fld1047 >= '#{before_visit_date}' \
  #     AND _document74._fld1047 < '#{after_visit_date}'")
  #
  #   table = nil
  #   if table_reservations_ext.ntuples > 0
  #     puts "30"
  #     reserved_tables = table_reservations_ext.map { |tr| tr['_fld1049rref'] }
  #     puts "reserved_tables: #{reserved_tables}"
  #
  #     all_tables = ExtService.execute("SELECT _reference27.* FROM _reference27").map { |tr| tr['_idrref'] }
  #     puts "all tables: #{all_tables}"
  #     all_tables.reject! {|x| reserved_tables.include?(x) }
  #     puts "all tables reject: #{all_tables}"
  #     if all_tables.length > 0
  #       puts "38"
  #       table = all_tables[0]
  #     else
  #       puts '41'
  #       render json: { errors: { visit_date: 'reserved' } }
  #       return false
  #     end
  #   else
  #     puts "40"
  #     table = TableExt.first._idrref
  #   end
  #
  #   puts "do with: #{table}"
  #
  #
  #   @reservation = Reservation.new user: current_user, visit_date: visit_date
  #   status = ReservStatusExt.where(_enumorder: 1).first
  #   date =  visit_date.strftime('%Y-%m-%d %R:01')
  #   date.freeze
  #   if status
  #     reserv_ext = TableReservExt.new _version: 0, _marked: false, _fld1048rref: status._idrref, _fld1050: 1.0
  #     reserv_ext._idrref = 2.times.map{ 20 + Random.rand(11) }.join() #SecureRandom.hex[0..3].bytes.join('\\')
  #     reserv_ext._date_time = DateTime.now
  #     reserv_ext._number = '1'
  #     reserv_ext._posted = true
  #     reserv_ext._fld1046 = "test"
  #     reserv_ext._fld1047 = date
  #     reserv_ext._fld1661rref = current_user.idrref#.join('\\')
  #     reserv_ext._fld1049rref = table
  #     reserv_iddref = ExtService.execute "INSERT INTO _document74 (_idrref, _marked, _fld1048rref, _fld1050, _number, _posted, _fld1046, _fld1047, _fld1661rref, _fld1049rref, _date_time) \
  #     VALUES (E'#{reserv_ext._idrref}', false, E'#{status._idrref}', 0, '#{reserv_ext._number}', true, E'#{reserv_ext._fld1046}', '#{date}', E'#{current_user.idrref}', E'#{reserv_ext._fld1049rref}', '#{DateTime.now.strftime('%Y-%m-%d %R:01')}') RETURNING _idrref"
  #
  #     @reservation.idrref = ExtService.execute("SELECT _idrref FROM _document74 WHERE _fld1661rref == E'#{current_user.idrref}' ORDER BY _idrref DESC LIMIT 1")[0]['_idrref']
  #   else
  #     raise "STATUS NOT FOUND IN 1C DATABASE"
  #   end
  #   if @reservation.save
  #     params[:meets].each do |user_id|
  #       user = User.find(user_id)
  #       if user
  #         Meet.create user: user, reservation: @reservation
  #       end
  #     end if params[:meets].present?
  #     render json: @reservation
  #   else
  #     render json: { errors: @reservation.errors }
  #   end
  # end


  def create
    visit_date = DateTime.parse(params[:visit_date])
    if visit_date < Time.now.utc.in_time_zone("Moscow") + 50.minutes
      render json: { errors: { visit_date: 'too_late' } }
      return false
    end
    before_visit_date = visit_date - 2.hours - 30.minutes
    after_visit_date = visit_date + 2.hours + 30.minutes

    reservations = Reservation.where('visit_date > ? AND visit_date <= ?', before_visit_date, after_visit_date)
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


    @reservation = Reservation.new user: current_user, visit_date: visit_date, table: table


    if @reservation.save!
      params[:meets].each do |user_id|
        user = User.find(user_id)
        if user
          Meet.create user: user, reservation: @reservation
        end
      end if params[:meets].present?
      render json: @reservation
    else
      render json: { errors: @reservation.errors }
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.user == current_user
      @reservation.destroy()
    end
    head :ok
  end

  def load_data
    @users = User.where.not(id: current_user.id)
    @lounges = Lounge.all.includes(:tables)
    #code
  end


end
