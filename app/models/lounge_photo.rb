class LoungePhoto < ActiveRecord::Base
  belongs_to :lounge
  mount_uploader :image, PhotoUploader
end
