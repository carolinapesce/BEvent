class Event < ApplicationRecord

  has_many :tickets
  has_many :favourites
  has_many :users, through: :favourites

  belongs_to :user

  has_one_attached :poster_pic
  
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
  

  def self.update_status
    now = Time.current
    where('start_datetime > ?', now).update_all(status: :upcoming)
    where('start_datetime <= ? AND end_datetime >= ?', now, now).update_all(status: :ongoing)
    where('end_datetime > ?', now).update_all(status: :terminated)
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

end
