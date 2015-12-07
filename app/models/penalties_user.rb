class PenaltiesUser < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :penalty
  belongs_to :user

  validates :penalty, :user, presence: true
end
