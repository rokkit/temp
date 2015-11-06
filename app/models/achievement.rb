class Achievement < ActiveRecord::Base
  validates :name, :key, presence: true
end
