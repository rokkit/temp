class ChangeRemoveFdefaultCountryRomUsers < ActiveRecord::Migration
  def change
    remove_column :users, :country
    add_column :users, :country, :string, default: ''
  end
end
