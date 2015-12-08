class AddTakenAtToSkillsUsers < ActiveRecord::Migration
  def change
    add_column :skills_users, :taken_at, :datetime
  end
end
