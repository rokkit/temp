class BonusUser < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :bonus, class_name: "Bonus"
  belongs_to :user

  validates :bonus, :user, presence: true
end
