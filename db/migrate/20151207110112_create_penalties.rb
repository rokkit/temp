class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :image

      t.timestamps null: false
    end
  end
end
