class Payment < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :user
  belongs_to :table
  belongs_to :reservation

  validates :amount, :user, :payed_at, presence: true
  validates :amount, :numericality => { :greater_than => 0 }

  after_create :add_exp_to_user

  after_initialize :init

  attr_accessor :user_phone # for autocomplete
  def user_phone
    @user_phone ||= self.try(:user).try(:phone)
    return @user_phone
  end

  def init
    self.payed_at = Time.zone.now if self.payed_at.nil?
  end


  def add_exp_to_user

    if !self.reservation
      self.user.add_exp_from_payment(self.amount.to_i)
    elsif self.reservation
      meets = Meet.where(reservation_id: reservation.id, status: 1)

      if meets.length > 0
        divided_exp = self.amount / (meets.length + 1)

        self.reservation.user.add_exp_from_payment(divided_exp.to_i)
        meets.each do |m|
          # puts m.user.total_experience.to_i.inspect
          m.user.add_exp_from_payment(divided_exp.to_i)
        end
      end
    end
  end
end
