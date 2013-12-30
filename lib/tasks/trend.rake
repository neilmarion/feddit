require 'open-uri'

namespace :trend do
  task :hot => :environment do
    create_trends JSON.parse(open(URI.encode("http://www.reddit.com/hot.json")).read)['data']['children']
  end

  task :newsletter => :environment do
    email_newsletter
  end
end

def create_trends(topics)
  topics.each do |topic|
    topic = topic['data']
    t = Topic.find_or_create_by _id: topic['permalink'],
      subreddit: topic['subreddit'],
      author: topic['author'],
      thumbnail: topic['thumbnail'],
      title: topic['title'],
      url: topic['url']
    t.ups = topic['ups']
    t.save
  end
end

def email_newsletter #email the daily newsletter
  topics = Topic.topics_today
  User.active_users.each do |user|
    Resque.enqueue(NewsletterEmailer, user._id, topics) 
  end
end
