class Api::V1::PaymentsController < ApplicationController
  respond_to :json
  # Внешнее API для принятия оповещений о новой оплате
  # от 1C
  # TODO: Пока непонятно какие данные кроме суммы мы можем получить от 1С
  def create
    user = User.find_by_phone(params[:phone])
    if user
      payment = Payment.new(user: user, amount: params[:amount])
      if payment.save
        # Добавить юзеру опыт по формуле от его суммы покупки в коллбеке
        head :ok if user.save
      end
    end
  end
end
