class Api::V1::Auth::SessionsController < Api::V1::BaseController
  respond_to :json
  # Создание сессии по номеру телефона и паролю.
  # Юзер должен быть подтвержденным по СМС.
  # Params: phone, password
  def create
    @user = User.find_by_phone(params[:phone])
    if @user
      @user.confirmed_at = DateTime.now
      @user.save
    end
    if @user
      if @user.confirmed_at.present?
        if @user.valid_password?(params[:password])
          respond_with @user
        else
          render json: { errors: { password: 'wrong password' } }
          return
        end
      else
        render json: { errors: { confirmed_at: 'user not confirmed' } }
        return
      end
    else
      render json: { errors: { phone: 'user not found' } }
      return
    end
  end

  # Восстановление пароля, путем отправки нового на телефон
  # Params: phone
  def forgot
    user = User.find_by_phone(params[:phone])
    if user
      new_password = Devise.friendly_token(5)
      user.update_attribute :password, new_password
      SMSService.send user.phone, "new password: #{new_password}"
      render json: { status: 'ok' }
    else
      render json: { status: 'error' }
    end
  end
end
