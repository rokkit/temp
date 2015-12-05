class AddEndDateToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :end_visit_date, :datetime
  end
end
