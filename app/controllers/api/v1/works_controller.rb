class Api::V1::WorksController < ApplicationController
  respond_to :json
  before_action :authenticate_user!
  # Получить список столиков для указанного заведения
  def index
    @works = Work.where(user_id: current_user.id).includes(:lounge)
             .order(work_at: :desc)
    respond_with @works
  end
end
