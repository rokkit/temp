class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  respond_to :json

  # Обновить профиль юезера
  def update
    @user = current_user
    if @user.update_attributes params.permit(:email, :password, :password_confirmation, :phone_token, :name, :city, :employe, :work_company, :hobby)
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
    if params[:role] == 'hookmaster'
      @users = User.hookmasters
    else
      @users = User.clients.where('experience > 0')
    end
    respond_with @users
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
