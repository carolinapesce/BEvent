class EventMailer < ApplicationMailer
  def event_updated(event, user)
    @user = user
    @event = event
    mail(to: user.email, from: @event.user.email, subject: "Aggiornamento sull'evento: #{@event.title}")
  end
end
