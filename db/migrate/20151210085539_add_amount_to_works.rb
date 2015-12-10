class AddAmountToWorks < ActiveRecord::Migration
  def change
    add_column :works, :amount, :decimal
  end
end
