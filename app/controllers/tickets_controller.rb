class TicketsController < ApplicationController

  load_and_authorize_resource

  def index
    @tickets = Ticket.where(user_id: current_user.id)
  end

  def download_pdf
    ticket = Ticket.find(params[:id])
    pdf = TicketPdf.generate_ticket(ticket.event, ticket, ticket.quantity)

    send_data pdf, 
              filename: "biglietti_#{ticket.event.title.parameterize}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end
  
end
