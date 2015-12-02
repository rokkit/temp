class AddExtIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :idrref, :binary
  end
end
