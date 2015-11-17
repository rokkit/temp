class Achievement < ActiveRecord::Base
  validates :name, :key, presence: true
  mount_uploader :image, AchievementUploader

  before_validation :generate_slug

  def generate_slug
    self.key = self.name.parameterize
  end
end
