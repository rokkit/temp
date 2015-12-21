class ChangeReservationsExt < ActiveRecord::Migration
  def change
    remove_column :reservations, :idrref
    add_column :reservations, :idrref, :string
  end
end
