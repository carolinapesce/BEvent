class Event < ApplicationRecord

  has_many :tickets
  has_many :reviews, dependent: :destroy

  
  #has_many :favourites
  has_many :users, through: :tickets
  has_many :favourites, dependent: :destroy
  has_many :favourite_users, through: :favourites, source: :user, dependent: :destroy

  after_create :set_stripe_event_id
  after_update :update_stripe_price_obj, if: :saved_change_to_event_price?

  validate :start_date_cannot_be_in_the_past
  validate :end_date_must_be_after_start_date

  belongs_to :user

  has_one_attached :poster_pic

  self.inheritance_column = :type
  
  enum :status, upcoming: 0, ongoing: 1, terminated: 2

  VALID_CATEGORIES = [
    "Musica",
    "Food&Drinks",
    "Comedy",
    "Teatro",
    "Sport",
    "Hobby",
    "Arte",
    "Festa"
  ]

  validates :category, inclusion: { in: VALID_CATEGORIES, message: "%{value} non è una categoria valida" }
  
  geocoded_by :full_address
  after_validation :geocode, if: :full_address_changed?

  def start_date_cannot_be_in_the_past
    if start_datetime.present? && start_datetime < Time.current
      errors.add(:start_datetime, "La data non può essere nel passato")
    end
  end

  def end_date_must_be_after_start_date
    if end_datetime.present? && start_datetime.present? && end_datetime <= start_datetime
      errors.add(:end_datetime, "L'orario di fine deve essere successivo all'orario di inizio")
    end
  end

  def favourited_by?(user = nil)
    return if user.nil?
    favourite_users.include?(user)
  end

  def full_address
    [address, city, country].compact.join(', ')
  end

  def full_address_changed?
    will_save_change_to_address? || will_save_change_to_city? || will_save_change_to_country?
  end

  def users_who_bought
    users.distinct
  end

  def self.update_status
    now = Time.current
    where('start_datetime > ?', now).update_all(status: :upcoming)
    where('start_datetime <= ? AND end_datetime >= ?', now, now).update_all(status: :ongoing)
    where('end_datetime < ?', now).update_all(status: :terminated)
  end

  def formatted_startdate
    start_datetime.to_date
  end

  def formatted_starttime
    start_datetime.strftime("%H:%M:%S")
  end

  def formatted_enddate
    end_datetime.to_date
  end

  def formatted_endtime
    end_datetime.strftime("%H:%M:%S")
  end

  def is_upcoming?
    start_datetime > Time.current
  end

  def is_ongoing?
    start_datetime < Time.current && end_datetime > Time.current
  end

  def has_ended?
    Time.current > end_datetime
  end
  
  def is_full?
    current_participants >= max_participants
  end

  def set_stripe_event_id 
    product = Stripe::Product.create(name: self.title, description: self.description.blank? ? nil : self.description)
    price = Stripe::Price.create(product: product, unit_amount: (self.event_price*100), currency: 'eur')
    update(stripe_event_id: product.id, stripe_price_id: price.id)
  end

  def update_stripe_price_obj 
    price = Stripe::Price.create(product: self.stripe_event_id, unit_amount: (self.event_price*100), currency: 'eur')
    update(stripe_price_id: price.id)
  end

  def update_average_rating
    avg_rating = reviews.average(:rating)
    update_column(:average_rating, avg_rating)
  end

end
