class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  respond_to :json

  # Обновить профиль юезера
  def update
    @user = current_user
    if @user.update_attributes params[:user].permit(:email, :password, :password_confirmation, :phone_token, :role, :name, :city, :employe, :work_company, :hobby)
       respond_with @user
    else
      render json: {status: :error}
    end
  end

  # Профиль юзера с количеством опыта
  def show
    @user = User.find(params[:id])
    respond_with @user
  end
end
