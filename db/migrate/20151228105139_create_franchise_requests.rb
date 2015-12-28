class CreateFranchiseRequests < ActiveRecord::Migration
  def change
    create_table :franchise_requests do |t|
      t.string :fio
      t.string :contact_phone
      t.string :email
      t.string :city
      t.string :about
      t.string :employe_phone
      t.string :employe_status
      t.string :first_payment
      t.string :total_payment

      t.timestamps null: false
    end
  end
end
