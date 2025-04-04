class TicketsController < ApplicationController

  load_and_authorize_resource

  def index
    @tickets = Ticket.where(user_id: current_user.id)
  end

  def download_pdf
    ticket = Ticket.find(params[:id])
    tot_quantity = Ticket.where(event_id: ticket.event_id, user_id: ticket.user_id).sum(:quantity)
    pdf = TicketPdf.generate_ticket(ticket.event, ticket, tot_quantity)

    send_data pdf, 
              filename: "biglietti_#{ticket.event.title.parameterize}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end
  
end
