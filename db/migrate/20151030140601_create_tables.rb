class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string :title
      t.references :lounge, index: true, foreign_key: true
      t.integer :seats

      t.timestamps null: false
    end
  end
end
