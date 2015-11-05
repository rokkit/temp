class Api::V1::SkillsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!

  # Полный список навыков с указанием родительского
  # навыка
  def index
    @skills = Skill.all.order(:id)
    respond_with @skills
  end

  # Добавить навык для пользователя
  # если у него есть такая возможность
  # TODO: проверка на возможность получения
  # TODO: снятие Очков навыка
  def take
    skill = Skill.find(params[:id])
    if skill
      current_user.skills.push skill
      if current_user.save
        render json: { status: :ok }
      else
        render json: { status: :error }
      end
    else
      head :not_found
    end
  end
end
