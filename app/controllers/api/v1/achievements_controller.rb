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
    @achievements = @achievements.sort_by {|h| [h.open?(current_user.id) ? 0 : 1,h[:id]]}
    respond_with @achievements
  end

  def viewed
    @achievement = Achievement.find(params[:id])
    if @achievement
      achievements_users = AchievementsUser.where(user_id: current_user.id, achievement_id: @achievement.id).first
      if achievements_users && achievements_users.viewed == false
        achievements_users.update_attribute :viewed, true
        render json: { status: 'ok' }
        return
      end
    end
    render json: { status: 'error' }
  end
end
