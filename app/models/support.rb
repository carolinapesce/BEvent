class Support
  include ActiveModel::Model

  attr_accessor :user, :subject, :message

  validates :subject, :message, presence: true
end
