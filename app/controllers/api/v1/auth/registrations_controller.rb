class Api::V1::Auth::RegistrationsController < Api::V1::BaseController
  respond_to :json
  # Создание аккаунта с отправкой кода подтверждения на указанный номер.
  # Params: phone, password
  def create
    user = User.new params.permit([:phone, :password])
    # TODO: когда будут СМС переключить на нормальный код
    user.phone_token = '1234'# 4.times.map { Random.rand(9) }.join
    if user.save
      sign_in user
      SMSService.send(user.phone, 'invite text')
      render json: { status: :ok }
    else
      render json: { errors: user.errors }
    end
  end
  # Поддтверждение аккаунта кодом, высланным на телефон при регистрации
  # Params: code
  def confirm
    @user = User.find_by_phone_token(params[:code])
    if @user
      @user.update_attribute :confirmed_at, DateTime.now
      sign_in @user
      respond_with @user
    else
      render json: { status: :error }
    end
  end
end
