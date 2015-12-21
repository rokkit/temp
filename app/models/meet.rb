class Meet < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :reservation
  belongs_to :user

  enum status: [:wait, :approved, :deleted]

  scope :wait, -> { where(status: 0) }
  scope :approved, -> { where(status: 1) }
  scope :active, -> { where('meets.status = 0 OR meets.status = 1') }
  scope :deleted, -> { where(status: 2) }

  after_create :send_sms_notify

  def self.format_status(status)
    statuses = {'wait': 'Ожидается', 'approved': 'Подтверждено', 'deleted': 'Отменено'}
    statuses[status.to_sym]
  end
  private
  def send_sms_notify
    text = "Вас пригласили на встречу"
    SMSService.send(self.user.phone, text)
  end
end
