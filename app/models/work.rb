class Work < ActiveRecord::Base
  belongs_to :lounge
  belongs_to :user

  after_initialize :init

  def init
    self.work_at = Time.zone.now if self.work_at.nil?
    self.end_work_at = Time.zone.now + 8.hours if self.work_at.nil?
  end
end
