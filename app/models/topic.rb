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

  index({created_at: 1, ups: -1}, {background: true})

  def self.topics_today
    where(:created_at => {:$lte => DateTime.now, :$gt => DateTime.now.yesterday}).desc(:ups).limit(25)
  end

  def self.email_newsletter #email the daily newsletter
    topics = self.topics_today
    User.active_users.each do |user|
      Resque.enqueue(NewsletterEmailer, user, topics) 
    end
  end

  def self.email_newsletter_to_user(user)
    topics = self.topics_today
    Resque.enqueue(NewsletterEmailer, user, topics) 
  end
end


