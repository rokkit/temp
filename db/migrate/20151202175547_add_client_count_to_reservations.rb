class AddClientCountToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :client_count, :integer
    add_column :reservations, :duration, :string
  end
end
