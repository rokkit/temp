class AddActiveToLounges < ActiveRecord::Migration
  def change
    add_column :lounges, :active, :boolean
  end
end
