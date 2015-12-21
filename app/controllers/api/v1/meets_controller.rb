class Api::V1::MeetsController < Api::V1::BaseController
  # Принятие приглашения
  respond_to :json
  def accept
    @meet = Meet.find(params[:id])
    if @meet.status == 'wait'
      @meet.status = :approved
      @meet.save!
      respond_with @meet
    end
  end
  def decline
    @meet = Meet.find(params[:id])
    puts @meet.status.inspect
    if @meet.status == 'wait' && @meet.status == 'approved'
      @meet.status = :deleted
      @meet.save!
      reservation = Reservation.find(@meet.reservation_id)
      # raise Meet.where(user: @meet.id, reservation_id: reservation.id).where.not(status: 2).inspect

      if !Meet.where(reservation_id: reservation.id).where.not(status: 2).present?
        reservation.status = :deleted
        reservation.save!
      end

      respond_with @meet
    end
  end
end
