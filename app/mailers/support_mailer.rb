class SupportMailer < ApplicationMailer
  default to: 'support@bevent.com'

  def support_email(support)
    @user = support.user
    @subject = support.subject
    @message = support.message

    mail(from: @user.email, subject: "Richiesta di supporto: #{@subject}")
  end
end
