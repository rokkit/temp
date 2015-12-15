class Meet < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :reservation
  belongs_to :user

  after_create :send_sms_notify

  private
  def send_sms_notify
    text = "Вас пригласили на встречу"
    SMSService.send(self.user.phone, text)
  end
end
