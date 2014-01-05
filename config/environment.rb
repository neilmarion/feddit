# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Feddit::Application.initialize!


SUBREDDITS = []

File.open(Rails.root.join("config/subreddits")).read.each_line do |line|
  SUBREDDITS << line.gsub!("\n", "")
end
