class Topic 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :_id, type: String #permalink
  field :subreddit, type: String
  field :author, type: String
  field :thumbnail, type: String
  field :title, type: String
  field :url, type: String 
  field :ups, type: Integer
  field :is_hot, type: Boolean

  index({created_at: 1, ups: -1}, {background: true})

  def self.topics_today(subreddit)
    if subreddit == "hot" 
      where(:created_at => {:$lte => DateTime.now, :$gt => DateTime.now.yesterday}, :is_hot => true).desc(:ups).limit(25)
    else
      where(:created_at => {:$lte => DateTime.now, :$gt => DateTime.now.yesterday}, :subreddit => subreddit).desc(:ups).limit(25)
    end
  end

  def self.email_newsletter #email the daily newsletter
    SUBREDDITS.each do |subreddit|
      topics = self.topics_today(subreddit)
      mailing_list = MailingList.where(_id: subreddit).first
      next if mailing_list.nil?
      mailing_list.emails do |email|
        Resque.enqueue(NewsletterEmailer, User.where(_id: email).first, topics, subreddit) 
      end
    end
  end

  def self.email_newsletter_to_user(user)
    user.subreddits.each do |subreddit|
      topics = self.topics_today(subreddit)
      Resque.enqueue(NewsletterEmailer, user, topics, subreddit) 
    end
  end

  def self.email_newsletter_to_user_by_subreddit(user, subreddit)
    topics = self.topics_today(subreddit)
    Resque.enqueue(NewsletterEmailer, user, topics, subreddit) 
  end
end


