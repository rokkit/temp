class City < ActiveRecord::Base
  establish_connection Rails.env.to_sym
end
