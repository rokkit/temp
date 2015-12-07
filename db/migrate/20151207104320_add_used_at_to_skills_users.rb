class AddUsedAtToSkillsUsers < ActiveRecord::Migration
  def change
    add_column :skills_users, :used_at, :datetime
  end
end
