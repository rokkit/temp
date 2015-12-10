class CreateBonus < ActiveRecord::Migration
  def change
    create_table :bonus do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :image

      t.timestamps null: false
    end
  end
end
