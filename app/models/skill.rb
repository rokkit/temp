class Skill < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  has_many :skills_users, class_name: 'SkillsUsers'
  has_many :users, through: :skills_users

  has_many :skills_links, class_name: 'SkillsLink'
  has_many :child_skills, through: :skills_links

  enum role: [:user, :hookmaster]

  validates :name, presence: true

  # belongs_to :parent, class_name: 'Skill'

  def parent_skills
    SkillsLink.where(child_id: self.id).map(&:parent).map(&:id)
  end
  def parent_skills_obj
    SkillsLink.where(child_id: self.id).map(&:parent)#.map(&:id)
  end

  def has?(user_id)
    SkillsUsers.where(user_id: user_id, skill_id: self.id).first.present?
  end

  # has_ancestry orphan_strategy: :adopt
  # has_closure_tree
  mount_uploader :image, SkillUploader
end
