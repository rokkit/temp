class Api::V1::MeetsController < Api::V1::BaseController
  # Принятие приглашения
  respond_to :json
  def accept
    @meet = Meet.find(params[:id])
    # if @meet.reservation.user == current_user
      @meet.status = :approved
      @meet.save!
      respond_with @meet
    # end
  end
  def decline
    @meet = Meet.find(params[:id])
    # if @meet.reservation.user == current_user
      @meet.status = :deleted
      reservation = Reservation.find(@meet.reservation_id)
      reservation.status = :deleted
      reservation.save!
      @meet.save!
      respond_with @meet
    # end
  end
end
