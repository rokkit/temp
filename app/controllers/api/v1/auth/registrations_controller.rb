class Api::V1::Auth::RegistrationsController < Api::V1::BaseController
  respond_to :json
  # Создание аккаунта с отправкой кода подтверждения на указанный номер.
  # Params: phone, password
  def create
    @user = User.new params.permit([:phone, :password, :name])
    # TODO: когда будут СМС переключить на нормальный код
    @user.phone_token = 4.times.map { Random.rand(9) }.join
    if @user.save
      @user.send_confirmation_token_to_phone
      sign_in @user
      respond_with @user
    else
      render json: { errors: @user.errors }
    end
  end
  # Поддтверждение аккаунта кодом, высланным на телефон при регистрации
  # Params: code, phone
  def confirm
    @user = User.find_by_phone(params[:phone])
    if @user && @user.phone_token == params[:code] && @user.confirmed_at.nil?
      @user.update_attribute :confirmed_at, DateTime.now
      if @user.phone_token.present?
        @user.phone_token = nil
        @user.save
      end
      respond_with @user
    else
      render json: { status: :error }
    end
  end


  #Отправить смс повторно
  def resend_code
    @user = User.find_by_phone(params[:phone])
    if @user
      if !@user.confirmed_at.present?
        if !@user.code_sent_at || @user.code_sent_at < DateTime.now - 5.minutes
          @user.send_confirmation_token_to_phone
        end
        render json: {status: 'ok'}
      end
    end
  end
end
