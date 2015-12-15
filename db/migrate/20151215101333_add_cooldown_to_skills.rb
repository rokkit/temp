class AddCooldownToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :cooldown, :integer
  end
end
