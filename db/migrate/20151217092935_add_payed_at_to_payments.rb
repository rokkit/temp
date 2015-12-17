class AddPayedAtToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :payed_at, :datetime
  end
end
