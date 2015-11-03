class AddAncestryToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :ancestry, :string
  end
end
