class CityPolicy
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
  def destroy_all?
    @current_user.is_admin?
  end
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if @user.is_admin?
        scope.all
      elsif @user.is_administrative?
        scope.where(id: @user.lounge.city_id)
      end
    end
  end
end
