class Lounge < ActiveRecord::Base
  belongs_to :city
  mount_uploader :blazon, BlazonUploader
end
