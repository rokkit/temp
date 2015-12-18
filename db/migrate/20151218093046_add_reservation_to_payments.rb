class AddReservationToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :reservation_id, :integer
  end
end
