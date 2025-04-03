class TicketsController < ApplicationController

  def index
    @tickets = Ticket.where(user_id: current_user.id)
  end
end
