class User < ApplicationRecord

  has_many :events
  has_many :favourites
  has_many :favourite_events, through: :favourites, source: :event

  # enum :role, user: 0, event_planner: 1, admin: 2

  has_one_attached :profile_pic

  validates :bio, absence: true, unless: :event_planner?

  def user?
    self.role == 0
  end

  def event_planner?
    self.role == 1
  end

  def admin?
    self.role == 2
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    where(uid: auth.uid, provider: auth.provider).first_or_create do |user|
      user.provider = auth.provider
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.city = auth.info.city
      user.phone_number = auth.info.phone_number
      user.skip_confirmation!
    end
  end


end
