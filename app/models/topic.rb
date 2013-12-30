class Topic 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :_id, type: String #permalink
  field :subreddit, type: String
  field :author, type: String
  field :thumbnail, type: String
  field :title, type: String
  field :ups, type: Integer

  index({created_at: 1, ups: -1}, {background: true})

  def self.topics_today
    where(:created_at => {:$lte => DateTime.now, :$gt => DateTime.now.yesterday}).desc(:ups)
  end
end
