class User < ActiveRecord::Base
  has_many :skills_users, class_name: 'SkillsUsers'
  has_many :skills, through: :skills_users

  has_many :payments


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
  validates_presence_of     :password, if: :password_required?
  # validates :email, uniqueness: true

  protected

      # Checks whether a password is needed or not. For validations only.
      # Passwords are always required if it's a new record, or if the password
      # or confirmation are being set somewhere.
      def password_required?
        !persisted? || !password.nil? || !password_confirmation.nil?
      end
end
