class Achievement < ActiveRecord::Base
  validates :name, :key, presence: true
  mount_uploader :image, AchievementUploader
end
