class AddUsedCountToSkillsUsers < ActiveRecord::Migration
  def change
    add_column :skills_users, :used_count, :integer, default: 0
  end
end
