class AddCountryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :country, :string, default: 'Россия'
  end
end
