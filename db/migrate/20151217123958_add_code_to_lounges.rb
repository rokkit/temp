class AddCodeToLounges < ActiveRecord::Migration
  def change
    add_column :lounges, :code, :string
  end
end
