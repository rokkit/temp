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

    user_skills = SkillsUsers.where(user_id: current_user.id)#.map(&:skill_id)
    @skills = @skills.sort_by {|h| [ user_skills.pluck(:skill_id).include?(h.id) ? 0 : 1,h[:id]]}
    respond_with @skills
  end

  # Добавить навык для пользователя
  # если у него есть такая возможность
  # TODO: проверка на возможность получения
  # TODO: снятие Очков навыка
  def take
    @skill = Skill.find(params[:id])

    user_skills = SkillsUsers.where(user_id: current_user.id)
    has_parent_skill = (user_skills.pluck(:skill_id) & @skill.parent_skills).present? || @skill.parent_skills.empty?
    has_enough_skill_points = current_user.skill_point >= @skill.cost

    can_parallel_take = false
    if current_user.role == 'hookmaster'
      can_parallel_take = user_skills.includes(:skill).where(skills: {cost: @skill.cost}).empty?
    else
      can_parallel_take = true
    end
    if has_enough_skill_points && !current_user.skills.include?(@skill) && has_parent_skill && can_parallel_take
      current_user.skills.push @skill
      current_user.skill_point -= @skill.cost
      if current_user.save
        skill_user = SkillsUsers.where(user_id: current_user.id, skill_id: @skill.id).first
        skill_user.update_attribute :taken_at, DateTime.now
        respond_with @skill
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
    @skill = Skill.find(params[:id])
    if current_user.skills.pluck(:id).include?(@skill.id) &&
      skill_user = SkillsUsers.where(skill_id: @skill.id, user_id: current_user.id).first
      if !skill_user.used_at || ( skill_user.cooldown_end_at && skill_user.cooldown_end_at <= Time.zone.now )
        skill_user.used_at = DateTime.now
        skill_user.used_count += 1
        # puts @skill.cooldown.inspect
        if @skill.cooldown
          skill_user.cooldown_end_at = skill_user.used_at + @skill.cooldown.days
        end
        skill_user.save
        respond_with @skill
      else
        render json: {errors: {cooldown: 'too_early_for_use'}}
      end
    end
  end
end
