require 'open-uri'

namespace :trend do
  task :hot => :environment do
    Trend.create! :content => JSON.parse(open(URI.encode("http://www.reddit.com/hot.json")).read) 
  end
end
