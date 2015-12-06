class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.references :lounge, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :work_at

      t.timestamps null: false
    end
  end
end
