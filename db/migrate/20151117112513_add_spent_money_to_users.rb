class AddSpentMoneyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :spent_money, :decimal, :precision => 8, :scale => 2
  end
end
