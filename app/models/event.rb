class Event < ApplicationRecord

  # belongs_to :user
  has_many :tickets
  has_many :favourites
  has_many :users, through: :events
  
  # enum status: { upcoming: 0, ongoing: 1, terminated: 2 }
  

  def self.update_status
    now = Time.current
    where('self.start_datetime > ?', now).update_all(status: :upcoming)
    where('self.start_datetime <= ? AND self.end_datetime >= ?', now, now).update_all(status: :ongoing)
    where('self.end_datetime > ?', now).update_all(status: :terminated)
  end

  def formatted_startdate
    start_datetime.to_date
  end

  def formatted_starttime
    start_datetime.strftime("%h:%m:%s")
  end

  def formatted_enddate
    end_datetime.to_date
  end

  def formatted_endtime
    end_datetime.strftime("%h:%m:%s")
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
