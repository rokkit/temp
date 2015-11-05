class Payment < ActiveRecord::Base
  belongs_to :user

  validates :amount, :user, presence: true
end
