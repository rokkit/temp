class Api::V1::PaymentsController < ApplicationController

  # Внешнее API для принятия оповещений о новой оплате
  # от 1C
  # TODO: Пока непонятно какие данные кроме суммы мы можем получить от 1С
  def create
    head :ok
  end
end
