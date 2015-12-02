class Meet < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :reservation
  belongs_to :user
end
