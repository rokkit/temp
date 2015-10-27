class Api::V1::Auth::RegistrationsController < ApplicationController
  # Создание аккаунта с отправкой кода подтверждения на указанный номер.
  # Параметры: phone, password
  def create
    user = User.new params.permit([:phone, :password])
    user.phone_token = 4.times.map{ Random.rand(9) }.join
    if user.save()
      sign_in user
      SMSService.send(user.phone, 'invite text')
      render json: user
    else
      render json: {errors: user.errors}
    end
  end

  # Поддтверждение аккаунта кодом, высланным на телефон при регистрации
  def confirm
    user = User.find_by_phone_token(params[:code])
    if user
      user.update_attribute :confirmed_at, DateTime.now
      sign_in user
      render json: { status: :ok }
    else
      render json: { status: :error }
    end
  end
end
