class AddLatlngToLounges < ActiveRecord::Migration
  def change
    add_column :lounges, :lat, :float
    add_column :lounges, :lng, :float
  end
end
