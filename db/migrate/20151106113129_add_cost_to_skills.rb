class AddCostToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :cost, :integer, default: 1
  end
end
