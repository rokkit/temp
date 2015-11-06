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
        # Добавить юзеру опыт по формуле от его суммы покупки
        user.experience += payment.amount * 0.01

        # Проверить количество опыта, не достигло ли оно следующего уровня
        # если достигло, то увеличить уровень и дать одно очко навыка
        if user.experience >= 1000
          user.level += 1
          user.skill_point += 1
        end

        head :ok if user.save
      end
    end
  end
end
