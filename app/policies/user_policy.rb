class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def index?
    @current_user.admin? || @current_user.is_administrative?
  end
  def new?
    @current_user.admin? || @current_user.is_administrative?
  end
  def create?
    @current_user.admin? || @current_user.is_administrative?
  end
  def show?
    @current_user.admin? || @current_user.is_administrative?
  end

  def update?
    @current_user.admin? || ((@current_user.is_franchiser? || @current_user.is_hookmaster?) && (@current_user.lounge == @model.lounge || @model.is_client?))
  end

  def freeze?
    @current_user.admin? || @current_user.is_administrative? && @model.is_client?
  end

  def destroy?
    @current_user.admin?  || @current_user.is_franchiser? && @model == @current_user.lounge
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
        if @user.is_administrative?
          scope.where('lounge_id =? OR role = 0', @user.lounge_id)
        end
      end
    end
  end
end
