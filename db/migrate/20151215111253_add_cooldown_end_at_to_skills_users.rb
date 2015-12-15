class AddCooldownEndAtToSkillsUsers < ActiveRecord::Migration
  def change
    add_column :skills_users, :cooldown_end_at, :datetime
  end
end
