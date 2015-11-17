class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  respond_to :json

  # Обновить профиль юезера
  def update
    @user = current_user
    if @user.update_attributes params[:user].permit(:name, :avatar, :email)
       respond_with @user
    else
      render json: {status: :error}
    end
  end
end