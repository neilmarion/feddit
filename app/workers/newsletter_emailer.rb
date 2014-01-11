class NewsletterEmailer
  @queue = :send_feddit_newsletters
  def self.perform(user, topics, subreddit)
    UserMailer.daily_trend_email(user, topics, subreddit).deliver
  end
end
