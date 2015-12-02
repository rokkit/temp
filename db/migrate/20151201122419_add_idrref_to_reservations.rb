class AddIdrrefToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :idrref, :binary
  end
end
