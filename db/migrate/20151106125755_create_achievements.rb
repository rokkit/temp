class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.text :description
      t.string :key, null: false

      t.timestamps null: false
    end
  end
end
