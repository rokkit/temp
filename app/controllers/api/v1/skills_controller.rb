class Api::V1::SkillsController < Api::V1::BaseController
  respond_to :json
  before_action :authenticate_user!

  # Полный список навыков с указанием родительского
  # навыка
  def index
    if params[:role] == 'user'
      @skills = Skill.where(role: 0).order(:id)
    elsif params[:role] == 'hookmaster'
      @skills = Skill.where(role: 1).order(:id)
    end
    respond_with @skills
  end

  # Добавить навык для пользователя
  # если у него есть такая возможность
  # TODO: проверка на возможность получения
  # TODO: снятие Очков навыка
  def take
    skill = Skill.find(params[:id])
    if skill && current_user.skill_point - skill.cost >= 0
      current_user.skills.push skill
      current_user.skill_point -= skill.cost
      if current_user.save
        render json: { status: :ok }
      else
        render json: { status: :error }
      end
    else
      render json: { status: :error }
    end
  end

  # Использовать навык юзером
  # если у него есть такая возможность
  def use
    skill = Skill.find(params[:id])
    if current_user.skills.pluck(:id).include?(skill.id)
      skill_user = SkillsUsers.where(skill_id: skill.id, user_id: current_user.id).first
      skill_user.used_at = DateTime.now
      skill_user.save
      render json: {status: :ok}
    end
  end
end
