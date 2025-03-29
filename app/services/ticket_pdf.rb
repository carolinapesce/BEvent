require 'prawn'

class TicketPdf
  def self.generate(event, order)
    Prawn::Document.new do |pdf|
      pdf.text "Biglietti per #{event.title}", size: 20, style: :bold
      pdf.move_down 10
      pdf.text "Nome Acquirente: #{order.user.first_name} #{order.user.last_name}"
      pdf.text "Data Evento: #{event.start_datetime.strftime('%d/%m/%Y')}"
      pdf.text "Luogo: #{event.address}, #{event.city}, #{event.country}"

      pdf.move_down 20
      pdf.text "Grazie per l'acquisto!", style: :italic
    end.render
  end
end