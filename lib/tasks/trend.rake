require 'open-uri'

namespace :trend do
  task :hot => :environment do
    SUBREDDITS.each do |subreddit|
      puts "fetching /r/#{subreddit} subreddit"
      create_trends JSON.parse(open(URI.encode("http://www.reddit.com/r/#{subreddit}.json")).read)['data']['children'], subreddit == "hot" ? true : false
    end
  end

  task :newsletter => :environment do
    Topic.email_newsletter
  end
end

def create_trends(topics, is_hot=false)
  topics.each do |topic|
    topic = topic['data']
    t = Topic.find_or_create_by _id: topic['permalink'],
      subreddit: topic['subreddit'],
      author: topic['author'],
      thumbnail: topic['thumbnail'],
      title: topic['title'],
      url: topic['url']
    t.ups = topic['ups']
    t.is_hot = true if is_hot
    t.save
  end
end


