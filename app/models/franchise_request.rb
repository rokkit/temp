class FranchiseRequest < ActiveRecord::Base
  validates :fio, presence: true
end
