class Reservation < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :table
  belongs_to :user
  validate :visit_date_must_be_in_future

  has_many :meets
  # has_many :meet_users, through: :meets, class_name: 'User'

  after_create :create_ext_record
  before_save :update_end_visit_date

  enum status: [:wait, :approve, :deleted]

  scope :wait, -> { where(status: 0) }
  scope :approved, -> { where(status: 1) }
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
    # status = ReservStatusExt.where(_enumorder: 1).first
    # date =  self.visit_date.strftime('%Y-%m-%d %R:01')
    # date.freeze
    # puts date.inspect
    # if status
    #   reserv_ext = TableReservExt.new _version: 0, _marked: false, _fld1048rref: status._idrref, _fld1050: 1.0
    #   reserv_ext._idrref = SecureRandom.hex[0..10].bytes
    #   # reserv_ext._date_time = self.created_at
    #   reserv_ext._number = 1
    #   reserv_ext._posted = true
    #   reserv_ext._fld1046 = "test"
    #   reserv_ext._fld1047 = date
    #   reserv_ext._fld1661rref = self.user.idrref
    #   reserv_ext._fld1049rref = TableExt.first._idrref
    #   reserv_ext.save
    # else
    #   raise "STATUS NOT FOUND IN 1C DATABASE"
    # end

  end

  # Валидатор для проверки даты бронирования
  # Дата должна быть больше текущей
  def visit_date_must_be_in_future
    errors.add(:visit_date, 'reservation.past_date') if visit_date < DateTime.now
  end
end
