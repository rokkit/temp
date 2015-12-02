class AchievementsUser < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :achievement
  belongs_to :user

  validates :achievement, :user, presence: true
end
