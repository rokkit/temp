class User < ActiveRecord::Base

  mount_uploader :blazon, BlazonUploader
  enum role: [:user, :admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  def is_admin?
    self.role == 'admin'
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable # , :validatable:confirmable

  validates :phone, presence: true, uniqueness: true
  validates :password, presence: true
  # validates :email, uniqueness: true
end
