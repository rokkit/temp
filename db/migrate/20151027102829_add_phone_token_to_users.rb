class AddPhoneTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_token, :string
    add_index :users, :phone_token
  end
end
