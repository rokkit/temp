class Achievement < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  validates :name, :key, presence: true
  mount_uploader :image, AchievementUploader
  enum role: [:user, :hookmaster]
  before_validation :generate_slug

  def generate_slug
    self.key = self.name.parameterize
  end
end
