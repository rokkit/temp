class AddOrderNumberToLounges < ActiveRecord::Migration
  def change
    add_column :lounges, :order_number, :integer
  end
end
