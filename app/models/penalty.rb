class Penalty < ActiveRecord::Base
  has_many :penalties_user
  has_many :users, through: :penalties_user

  validates :name, :slug, presence: true
  mount_uploader :image, AchievementUploader

  before_validation :generate_slug

  def generate_slug
    self.slug = self.name.parameterize
  end
end
