class AddCodeToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :code, :string
  end
end
