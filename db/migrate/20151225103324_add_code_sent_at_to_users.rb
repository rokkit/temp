class AddCodeSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :code_sent_at, :datetime
  end
end
