class Work < ActiveRecord::Base
  belongs_to :lounge
  belongs_to :user
end
