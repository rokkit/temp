class Penalty < ActiveRecord::Base
  has_many :penalties_user
  has_many :users, through: :penalties_user

  validates :name, :slug, presence: true
  mount_uploader :image, AchievementUploader

  before_validation :generate_slug

  def generate_slug
    self.slug = self.name.parameterize
  end

  def has?(user_id, penalties_users)
    penalties_users.where(user_id: user_id, penalty_id: self.id).first.present?
  end
end
