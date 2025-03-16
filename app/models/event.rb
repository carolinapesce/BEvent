class Event < ApplicationRecord

  # belongs_to :user
  has_many :tickets

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

  def has_ended?
    Time.current > end_datetime
  end

end
