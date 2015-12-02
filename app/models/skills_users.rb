class SkillsUsers < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :user
  belongs_to :skill
end
