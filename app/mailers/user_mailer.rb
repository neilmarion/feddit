class UserMailer < ActionMailer::Base
  default from: "noreply@fedd.it"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.subscription_confirmation.subject
  #
  def subscription_confirmation(user)
    @greeting = "Hi"

    mail to: user._id, subject: "Confirm Subscription"
  end

  def activation_needed_email(user)
    @user = user
    @url  = "http://0.0.0.0:3000/users/#{user.activation_token}/activate"
    mail(:to => user._id,
      :subject => "Welcome")
  end
end
