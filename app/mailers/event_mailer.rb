class EventMailer < ApplicationMailer
  def event_updated(event, user)
    @event = event
    mail(to: user.email, from: @event.user_id.email subject: "Aggiornamento sull'evento: #{@event.title}")
  end
end
