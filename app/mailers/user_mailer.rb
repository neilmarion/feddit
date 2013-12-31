require 'mail'

class UserMailer < ActionMailer::Base
  address = Mail::Address.new "subscribe@fedd.it"
  address.display_name = "Feddit"
  default from: address.format

  def activation_success_email(user)
    @greeting = "Hi"

    mail to: user._id, subject: "Thanks for Subscribing"
  end

  def activation_needed_email(user)
    @user = user
    @base_url = "http://#{ActionMailer::Base.default_url_options[:host]}"
    @activation_url  = "http://#{ActionMailer::Base.default_url_options[:host]}/users/#{user.token}/activate"

    mail(:to => user._id,
      :subject => "Welcome")
  end

  def deactivation_success_email(user)
    @user = user
    @base_url = "http://#{ActionMailer::Base.default_url_options[:host]}"
    @activation_url  = "http://#{ActionMailer::Base.default_url_options[:host]}/users/#{user.token}/activate"
    mail(:to => user._id,
      :subject => "So sad! You have unsubscribed.")
  end

  def daily_trend_email(user, topics)
    @topics = topics
    @colors = colors 
    address = Mail::Address.new "newsletter@fedd.it"
    address.display_name = "Feddit"

    @base_url = "http://#{ActionMailer::Base.default_url_options[:host]}"
    @deactivation_url  = "http://#{ActionMailer::Base.default_url_options[:host]}/users/#{user['token']}/deactivate"

    mail(:to => user['_id'],
      :subject => "Top Stories of the Day",
      :from => address.format)
  end

  private

  def colors
    ["#e74c3c", "#e67e22", "#f1c40f", "#34495e", "#9b59b6", 
      "#3498db", "#2ecc71", "#1abc9c", "#c0392b", "#d35400", 
      "#f39c12", "#2c3e50", "#8e44ad", "#2980b9", "#27ae60", 
      "#16a085", "#520E24", "#005A55", "#CF3510", "#BF717F",
      "#7AD7EE", "#F06050", "#00948A", "#63D3E9", "#0EA46E"]
  end
end
