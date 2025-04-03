require 'prawn'

class TicketPdf
  def self.generate_checkout(event, order, quantity)
    Prawn::Document.new do |pdf|
      quantity.times do |i|
        pdf.text "----------------------------------------------------------------------------------------------------------------"
        pdf.text "Biglietto ##{i + 1} per l'evento: #{event.title}", size: 20, style: :bold
        pdf.move_down 10
        pdf.text "Nome Acquirente: #{order.user.first_name} #{order.user.last_name}"
        pdf.text "Data Evento: #{event.start_datetime.strftime('%d/%m/%Y')}"
        pdf.text "Luogo: #{event.address}, #{event.city}, #{event.country}"
        pdf.text "----------------------------------------------------------------------------------------------------------------"
      end
    end.render
  end

  def self.generate_ticket(event, ticket, quantity)
    Prawn::Document.new do |pdf|
      quantity.times do |i|
        pdf.text "----------------------------------------------------------------------------------------------------------------"
        pdf.text "Biglietto ##{i + 1} per l'evento: #{event.title}", size: 20, style: :bold
        pdf.move_down 10
        pdf.text "Nome Acquirente: #{ticket.user.first_name} #{ticket.user.last_name}"
        pdf.text "Data Evento: #{event.start_datetime.strftime('%d/%m/%Y')}"
        pdf.text "Luogo: #{event.address}, #{event.city}, #{event.country}"
        pdf.text "----------------------------------------------------------------------------------------------------------------"
      end
    end.render
  end
end