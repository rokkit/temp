class AddTableToPayments < ActiveRecord::Migration
  def change
    add_reference :payments, :table, index: true, foreign_key: true
  end
end
