class AddRoleToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :role, :integer
  end
end
