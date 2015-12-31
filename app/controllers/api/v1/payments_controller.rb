class Api::V1::PaymentsController < Api::V1::BaseController
  respond_to :json
  # Внешнее API для принятия оповещений о новой оплате
  # от 1C
  # TODO: Пока непонятно какие данные кроме суммы мы можем получить от 1С
  def create
    user = User.find_by_phone(params[:phone])
    params[:amount] ||= 100.0
    if user

      payments_ext = user.get_payments_from_ext()
      total_amount = payments_ext.map { |p| p['_Fld1574'] }.reduce(0) { |a, sum| sum += a }.to_f

      if total_amount > 0 && total_amount > user.experience
        amount_diff = total_amount - user.experience
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
        else
          render json: {error: 'wrong_payment_data'}
          return
        end
      else
        render json: {error: 'zero_payments'}
        return
      end


    else
      render json: {error: 'user not found'}
    end
  end
end
