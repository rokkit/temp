class AddRowToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :row, :integer
  end
end
