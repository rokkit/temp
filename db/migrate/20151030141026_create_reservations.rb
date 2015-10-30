class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :table, index: true, foreign_key: true
      t.datetime :visit_date
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
