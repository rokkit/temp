class AchievementsUser < ActiveRecord::Base
  belongs_to :achievement
  belongs_to :user

  validates :achievement, :user, presence: true
end
