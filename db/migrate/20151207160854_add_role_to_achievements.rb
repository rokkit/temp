class AddRoleToAchievements < ActiveRecord::Migration
  def change
    add_column :achievements, :role, :integer
  end
end
