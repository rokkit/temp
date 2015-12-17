class Payment < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :user
  belongs_to :table

  validates :amount, :user, :payed_at, presence: true
  validates :amount, :numericality => { :greater_than => 0 }

  after_save :add_exp_to_user

  after_initialize :init

  def init
    self.payed_at = Time.zone.now if self.payed_at.nil?
  end


  def add_exp_to_user
    self.user.add_exp_from_payment(self.amount.to_i)
  end
end
