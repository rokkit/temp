class Api::V1::AchievementsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!

  # Список всех достижений в системе
  # Если какое-либо достижение открыто у юзера,
  # то оно отмечается значением в ответе
  def index

    if params[:role] == 'hookmaster'
      @achievements = Achievement.where(role: 1).order(:id)
    else
      @achievements = Achievement.where(role: 0).order(:id)
    end
    respond_with @achievements
  end
end
