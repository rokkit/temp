class Api::V1::PaymentsController < Api::V1::BaseController
  respond_to :json
  # Внешнее API для принятия оповещений о новой оплате
  # от 1C
  # TODO: Пока непонятно какие данные кроме суммы мы можем получить от 1С
  def create
    user = User.find_by_phone(params[:phone])
    params[:amount] ||= 100
    if user
      payment = Payment.new(user: user, amount: params[:amount])
      if params[:reservation_code].present?
        reservation = Reservation.where(code: params[:reservation_code]).first
        if reservation
          payment.reservation = reservation
        end
      end
      if payment.save
        head :ok
        return
      end
    else
      render json: {error: 'user not found'}
    end
  end
end
