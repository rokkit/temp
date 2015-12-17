class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  respond_to :json

  # Обновить профиль юезера
  def update
    @user = current_user
    if @user.update_attributes params.permit(:avatar,
                                             :password,
                                             :password_confirmation,
                                             :phone,
                                             :name,
                                             :city,
                                             :country,
                                             :employe,
                                             :work_company,
                                             :hobby)
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
      @users_month = @users_all_time = User.hookmasters
    else
      @users_all_time = User.clients.where('experience > 0')
      @users_month = Payment.includes(:user)
      .where('payments.payed_at >= ? AND payments.payed_at <= ?',current_month_start, current_month_end).map(&:user)
      .sort_by { |u| u.total_experience }
    end
    respond_with @users_month, @users_all_time
  end


  def load_client_data

  end

  def load_hookmaster_data
    @user = User.find(params[:id])
    @user_skills = SkillsUsers.where(user_id: @user.id)
    @skills = Skill.where(role: 1).order(:id)
    @achievements = Achievement.where(role: 1).order(:id)
    @penalties = PenaltiesUser.where(user_id: @user.id).includes(:penalty).order(:id).map(&:penalty)
    @bonuses = BonusUser.where(user_id: @user.id).includes(:bonus).order(:id).map(&:bonus)
    @works = Work.where(user_id: @user.id).includes(:lounge)
             .order(work_at: :desc)
  end
end
