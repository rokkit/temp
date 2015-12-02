class AddVipToTables < ActiveRecord::Migration
  def change
    add_column :tables, :vip, :boolean
  end
end
