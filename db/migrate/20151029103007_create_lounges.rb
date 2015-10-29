class CreateLounges < ActiveRecord::Migration
  def change
    create_table :lounges do |t|
      t.string :title
      t.references :city, index: true, foreign_key: true
      t.string :color
      t.string :blazon

      t.timestamps null: false
    end
  end
end
