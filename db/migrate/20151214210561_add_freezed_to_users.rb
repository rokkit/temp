class AddFreezedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :freezed, :boolean
  end
end
