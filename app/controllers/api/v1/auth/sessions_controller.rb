class Api::V1::Auth::SessionsController < ApplicationController
  # Создание сессии по номеру телефона и паролю
  # Параметры: phone, password
  def create
    user = User.find_by_phone(params[:phone])
    if user
      if user.valid_password?(params[:password])
        render json: user
      else
        render json: { errors: { password: 'wrong password' } }
      end
    else
      render json: { errors: { phone: 'user not found' } }
    end
  end

  # Восстановление пароля, путем отправки нового на телефон
  def forgot
    user = User.find_by_phone(params[:phone])
    if user
      new_password = Devise.friendly_token(5)
      user.update_attribute :password, new_password
      SMSService.send user.phone, "new password: #{new_password}"
      head :ok
    else
      render json: { status: 'error' }
    end
  end
end
