class SupportMailer < ApplicationMailer
  def support_email(support)
    @user = support.user
    @subject = support.subject
    @message = support.message

    mail(to: 'support@bevent.com', from: @user.email, subject: "Richiesta di supporto: #{@subject}")
  end

  def response_email(support)
    @user = support.user
    @response = support.response
    @subject = support.subject

    mail(to: @user.email, from: 'support@bevent.com', subject: "Risposta alla tua richiesta di supporto: '#{@subject}'")
  end
end
