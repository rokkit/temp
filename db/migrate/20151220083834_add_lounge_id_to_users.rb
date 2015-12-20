class AddLoungeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lounge_id, :integer
  end
end
