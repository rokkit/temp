class Reservation < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :table
  belongs_to :user
  validate :visit_date_must_be_in_future

  has_many :meets, dependent: :delete_all
  # has_many :meet_users, through: :meets, class_name: 'User'

  after_create :create_ext_record
  before_save :update_end_visit_date

  enum status: [:wait, :approve, :deleted]

  scope :wait, -> { where(status: 0) }
  scope :approved, -> { where(status: 1) }
  scope :active, -> { where('reservations.status = 0 OR reservations.status = 1') }
  scope :deleted, -> { where(status: 2) }

  ransacker :containing_lounge_table,
          :formatter => ->(lounge) {
             results = joins(:table).where("tables.lounge_id = ?", lounge).map(&:id)
             results = results.present? ? results : nil
          }, splat_params: true do |parent|
      parent.table[:id]
  end

  private
  def update_end_visit_date
    if self.user.role == 'vip'
      self.end_visit_date = self.visit_date + 2.hours + 30.minutes
    else
      self.end_visit_date = self.visit_date + 1.hours + 30.minutes
    end
  end
  def create_ext_record
    # SoapService.call(:reserve_save, message: {
    #   'КодСтола' => self.table.number,
    #   'ДатаРезерва' => self.visit_date,
    #   'Статус' => 'Активен',
    #   'Дата' => Time.zone.now
    # })
  end

  # Валидатор для проверки даты бронирования
  # Дата должна быть больше текущей
  def visit_date_must_be_in_future
    errors.add(:visit_date, 'reservation.past_date') if visit_date < DateTime.now
  end
end
