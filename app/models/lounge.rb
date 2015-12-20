class Lounge < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :city
  mount_uploader :blazon, BlazonUploader

  has_many :tables
  has_many :hookmasters, class_name: 'User'
end
