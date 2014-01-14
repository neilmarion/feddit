require 'open-uri'

namespace :trend do
  task :hot => :environment do
    SUBREDDITS.each do |subreddit|
      if subreddit == "hot"
        puts "fetching #{subreddit} subreddit"
        url = "http://www.reddit.com/#{subreddit}.json"
      else
        puts "fetching /r/#{subreddit} subreddit"
        url = "http://www.reddit.com/r/#{subreddit}.json"
      end
      create_trends JSON.parse(open(URI.encode(url)).read)['data']['children'], subreddit == "hot" ? true : false
    end
  end

  task :newsletter => :environment do
    Topic.email_newsletter
  end

  task :email_admin_newsletter  => :environment do
    Topic.email_newsletter_to_user(User.find_by(id: "neilmarion@freelancer.com"))
  end

  task :email_admin_all_newsletter => :environment do
    SUBREDDITS.each do |subreddit|
      Topic.email_newsletter_to_user_by_subreddit(User.find_by(id: "neilmarion@freelancer.com"), subreddit)
    end
  end

  task :create_newsletters => :environment do
    SUBREDDITS.each do |subreddit|
      topics = Topic.topics_today(subreddit)
      newsletter = Newsletter.find_or_create_by(_id: subreddit)
      newsletter.topics = topics.collect{|x| 
        {_id: x['_id'], author: x['author'], created_at: x['created_at'], is_hot: x['is_hot'], 
          subreddit: x['subreddit'], thumbnail: x['thumbnail'], title:x['title'], updated_at: x['updated_at'], 
          ups: x['ups'], url: x['url']}}
      newsletter.save
    end
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


