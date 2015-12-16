class AddPartyCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :party_count, :integer, default: 0
  end
end
