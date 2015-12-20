class Lounge < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  belongs_to :city
  mount_uploader :blazon, BlazonUploader

  has_many :tables
  has_many :hookmasters, class_name: 'User'
  has_many :photos, class_name: 'LoungePhoto'

  accepts_nested_attributes_for :photos, :allow_destroy => true
end
