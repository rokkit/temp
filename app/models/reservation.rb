class Reservation < ActiveRecord::Base
  belongs_to :table
  belongs_to :user
  validate :visit_date_must_be_in_future

  private

  # Валидатор для проверки даты бронирования
  # Дата должна быть больше текущей
  def visit_date_must_be_in_future
    errors.add(:visit_date, 'reservation.past_date') if visit_date < DateTime.now
  end
end
