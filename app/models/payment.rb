class Payment < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :user
  belongs_to :table
  belongs_to :reservation

  validates :amount, :user, :payed_at, presence: true
  validates :amount, :numericality => { :greater_than => 0 }

  after_create :add_exp_to_user

  after_initialize :init

  def init
    self.payed_at = Time.zone.now if self.payed_at.nil?
  end


  def add_exp_to_user

    if !self.reservation
      self.user.add_exp_from_payment(self.amount.to_i)
    elsif self.reservation
      meets = Meet.where(reservation_id: reservation.id)

      if meets.length > 0

        divided_exp = self.amount / (meets.length + 1)
        self.user.add_exp_from_payment(divided_exp.to_i)
        meets.each { |m| m.user.add_exp_from_payment(divided_exp.to_i) }
      end
    end
  end
end
