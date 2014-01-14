class Newsletter
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :_id, type: String #subreddit
  field :topics, type: Array, default: []
end
