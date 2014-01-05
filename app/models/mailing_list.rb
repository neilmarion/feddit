class MailingList
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String #subreddit
  field :emails, type: Array 

  def insert_email email
    self.add_to_set({emails: email})
    self.save
  end
end
