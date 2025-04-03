class UserMailer < ApplicationMailer
  default from: 'support@bevent.com'

  def account_blocked(user)
    @user = user
    mail(to: @user.email, subject: "Il tuo account è stato bloccato")
  end
end
