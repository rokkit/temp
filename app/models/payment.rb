class Payment < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :user

  validates :amount, :user, presence: true
end
