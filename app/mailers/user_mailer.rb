class UserMailer < ActionMailer::Base
  default from: "subscribe@fedd.it"

  def activation_success_email(user)
    @greeting = "Hi"

    mail to: user._id, subject: "Thanks for Subscribing"
  end

  def activation_needed_email(user)
    @user = user
    @url  = "http://#{ActionMailer::Base.default_url_options[:host]}/users/#{user.token}/activate"
    mail(:to => user._id,
      :subject => "Welcome")
  end

  def daily_trend_email(email, topics)
    @topics = topics
    mail(:to => email,
      :subject => "Top Stories of the Day",
      :from => "newsletter@fedd.it")
  end
end
