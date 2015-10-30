class Table < ActiveRecord::Base
  belongs_to :lounge
  validates :lounge, :title,  presence: true
end
