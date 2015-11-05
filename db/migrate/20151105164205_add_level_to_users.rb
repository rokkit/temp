class AddLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :level, :integer, default: 1
    add_column :users, :skill_point, :integer, default: 0
  end
end
