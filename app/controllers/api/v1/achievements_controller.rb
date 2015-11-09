class Api::V1::AchievementsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!

  # Список всех достижений в системе
  # Если какое-либо достижение открыто у юзера,
  # то оно отмечается значением в ответе
  def index
    @achievements = Achievement.all
    respond_with @achievements
  end
end
