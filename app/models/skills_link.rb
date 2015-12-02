class SkillsLink < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :parent, class_name: 'Skill'
  belongs_to :child, class_name: 'Skill'

  validates :parent, :child, presence: true
end
