class EventMailer < ApplicationMailer
  def event_user_updated(event, user)
    @user = user
    @event = event
    mail(to: user.email, from: @event.user.email, subject: "Aggiornamento sull'evento: #{@event.title}")
  end
  def event_planner_updated(event, user)
    @user = user
    @event = event
    mail(to: user.email, from: @event.user.email, subject: "Aggiornamento sull'evento: #{@event.title}")
  end
end
