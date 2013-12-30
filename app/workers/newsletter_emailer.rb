class NewsletterEmailer
  @queue = :send_feddit_newsletters
  def self.perform(email, topics)
    UserMailer.daily_trend_email(email, topics).deliver
  end
end
