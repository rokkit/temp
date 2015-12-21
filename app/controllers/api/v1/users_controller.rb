class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  respond_to :json

  # Обновить профиль юезера
  def update
    @user = current_user
    if @user.update_attributes params.permit(:avatar,
                                             :name,
                                             :city,
                                             :country,
                                             :employe,
                                             :work_company,
                                             :hobby,
                                             :birthdate)

       if params[:old_password].present? && params[:new_password].present? && @user.valid_password?(params[:old_password])
         @user.password = params[:new_password]
         @user.save
       end
       respond_with @user
    else
      render json: {status: :error}
    end
  end

  # Профиль юзера с количеством опыта
  def show
    @user = User.find(params[:id])
    respond_with @user
  end

  def rating
    current_month_start = Time.zone.now.beginning_of_month
    current_month_end = Time.zone.now.end_of_month
    if params[:role] == 'hookmaster'
      @users_all_time = User.hookmasters.joins(:works).uniq.sort_by { |u| u.total_experience }.reverse


      works = Work.where('works.work_at >= ? AND works.work_at <= ?',current_month_start, current_month_end)
      @users_month = works.map(&:user).uniq.sort_by { |u| u.total_experience }.reverse
      @users_expiriences = {}
      @users_month.each do |user|
        month_amount = works.where(user_id: user.id).map(&:amount).reduce(0) { |amount, sum| sum += amount }
        @users_expiriences[user.id] = month_amount
      end
    else
      @users_all_time = User.clients.where('experience > 0').order(experience: :desc)

      payments = Payment.includes(:user)
      .where('payments.payed_at >= ? AND payments.payed_at <= ?',current_month_start, current_month_end)
      @users_month = payments.map(&:user).uniq.sort_by { |u| u.total_experience }
      @users_expiriences = {}
      @users_month.each do |user|
        month_amount = payments.where(user_id: user.id).map(&:amount).reduce(0) { |amount, sum| sum += amount }
        @users_expiriences[user.id] = month_amount
      end

    end
    respond_with @users_month, @users_all_time
  end


  def load_client_data
    @user = User.find(params[:id])
    @user_skills = SkillsUsers.where(user_id: @user.id).includes(:skill)
    @skills = Skill.where(role: 0).order(:id)
    @achievements = Achievement.where(role: 0).order(:id)

    @users = User.where.not(id: @user.id)
    @lounges = Lounge.where(active: true).includes(:tables)
    @payments = @user.payments
    @meets = Meet.active.where(user_id: @user.id).joins(:reservation).includes(:reservation).where('reservations.visit_date > ?', Time.zone.now)
  end

  def load_hookmaster_data
    @user = User.find(params[:id])
    @user_skills = SkillsUsers.where(user_id: @user.id)
    @skills = Skill.where(role: 1).order(:id)
    @achievements = Achievement.where(role: 1).order(:id)

    @penalties_users = PenaltiesUser.where(user_id: @user.id)
    @penalties = Penalty.all.order(:id)
    @penalties = @penalties.sort_by {|h| [h.has?(@user.id, @penalties_users) ? 0 : 1,h[:id]]}

    @bonuses_users = BonusUser.where(user_id: @user.id)
    @bonuses = Bonus.all.order(:id)
    @bonuses = @bonuses.sort_by {|h| [h.has?(@user.id, @bonuses_users) ? 0 : 1,h[:id]]}

    @works = Work.where(user_id: @user.id).includes(:lounge)
             .order(work_at: :desc)
  end
end
