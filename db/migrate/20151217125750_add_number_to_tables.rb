class AddNumberToTables < ActiveRecord::Migration
  def change
    add_column :tables, :number, :string
  end
end
