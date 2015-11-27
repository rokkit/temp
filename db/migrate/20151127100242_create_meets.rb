class CreateMeets < ActiveRecord::Migration
  def change
    create_table :meets do |t|
      t.references :reservation, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
