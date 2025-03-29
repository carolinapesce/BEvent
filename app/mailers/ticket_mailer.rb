class TicketMailer < ApplicationMailer
  default from: 'no-reply@bevent.com'

  def confirmation(order)
    @order = order

    @order.cart_items.each do |item|
      pdf_content = TicketPdf.generate(item.event, @order, item.quantity)  
      attachments["biglietti_#{item.event.title.parameterize}.pdf"] = pdf_content
    end

    mail(to: @order.user.email, subject: "Conferma acquisto biglietti")
  end
end
