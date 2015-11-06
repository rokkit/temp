class AchievementPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def index?
    @current_user.is_admin?
  end

  def new?
    @current_user.is_admin?
  end

  def create?
    @current_user.is_admin?
  end

  def show?
    @current_user.is_admin?
  end

  def update?
    @current_user.is_admin?
  end

  def destroy?
    @current_user.is_admin?
  end
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
