class Bonus < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :name, :slug, presence: true
  mount_uploader :image, AchievementUploader

  before_validation :generate_slug

  def generate_slug
    self.slug = self.name.parameterize
  end
end