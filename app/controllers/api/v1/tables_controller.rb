class Api::V1::TablesController < ApplicationController
  respond_to :json
  # Получить список столиков для указанного заведения
  def index
    lounge = Lounge.find(params[:lounge_id])
    if lounge
      @tables = lounge.tables
      respond_with @tables
    end
  end
end
