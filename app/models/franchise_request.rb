class FranchiseRequest < ActiveRecord::Base
  validates :fio, presence: true

  after_create :send_inform

  def send_inform
    FranchiseMailer.new_request(self).deliver_now!
  end
end
