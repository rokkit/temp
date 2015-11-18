class Skill < ActiveRecord::Base
  has_many :skills_users, class_name: 'SkillsUsers'
  has_many :users, through: :skills_users

  has_ancestry orphan_strategy: :adopt
  mount_uploader :image, SkillUploader
end
