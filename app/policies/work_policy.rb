class WorkPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def index?
    @current_user.is_admin? || @current_user.is_administrative?
  end

  def show?
    @current_user.is_admin? || (@current_user.is_franchiser? || @current_user.is_hookmaster?) && @current_user.lounge == @model.lounge
  end

  def new?
    @current_user.is_admin? || (@current_user.is_franchiser? || @current_user.is_hookmaster?) && @current_user.lounge == @model.lounge
  end

  def create?
    @current_user.is_admin? || (@current_user.is_franchiser? || @current_user.is_hookmaster?) && @current_user.lounge == @model.lounge
  end

  def update?
    @current_user.is_admin? || (@current_user.is_franchiser? || @current_user.is_hookmaster?) && @current_user.lounge == @model.lounge
  end

  def destroy?
    return false if @current_user == @model
    @current_user.is_admin? || @current_user.is_administrative?
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
      else
        scope.where(user_id: @user.id)
      end
    end
  end
end
