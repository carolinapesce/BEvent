class User < ApplicationRecord

  has_many :events

  # Definition of roles (User, EventPlanner, Admin)
  def user?
    self.role == 0
  end

  def eventplanner?
    self.role == 1
  end
  def admin?
    self.role == 2
  end

  validates :bio, absence: true, unless: :eventplanner?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.provider = auth.info.provider
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.city = auth.info.city
      user.phone_number = auth.info.phone_number
    end
  end


end
