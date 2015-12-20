class Api::V1::Auth::RegistrationsController < Api::V1::BaseController
  respond_to :json
  # Создание аккаунта с отправкой кода подтверждения на указанный номер.
  # Params: phone, password
  def create
    user = User.new params.permit([:phone, :password, :name])
    # TODO: когда будут СМС переключить на нормальный код
    user.phone_token = 4.times.map { Random.rand(9) }.join
    if user.save
      user.send_confirmation_token_to_phone
      render json: { status: :ok }
    else
      render json: { errors: user.errors }
    end
  end
  # Поддтверждение аккаунта кодом, высланным на телефон при регистрации
  # Params: code
  def confirm
    @user = User.find_by_phone_token(params[:code])
    if @user && @user.confirmed_at.nil?
      @user.update_attribute :confirmed_at, DateTime.now
      sign_in @user
      respond_with @user
    else
      render json: { status: :error }
    end
  end
end
