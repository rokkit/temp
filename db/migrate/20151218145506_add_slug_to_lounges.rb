class AddSlugToLounges < ActiveRecord::Migration
  def change
    add_column :lounges, :slug, :string
  end
end
