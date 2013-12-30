# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every '0,5,10,15,20,25,30,35,40,45,50,55 * * * *' do
  rake "trend:newsletter" 
end

every '2,7,12,17,22,27,32,37,42,47,52,57 * * * *' do
  rake "trend:hot" 
end
