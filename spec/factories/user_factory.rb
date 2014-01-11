FactoryGirl.define do
  subreddits = ['hot', 'pics']
  blank = []
  factory :user do
    sequence(:_id) { |n| "user#{n}@email.com" }
    subreddits subreddits 
  end

  factory :user_activated, :parent => :user do
    is_active true
    sequence(:token) { |n| "#{n}" }
    after :build do |user_activated|
      subreddits.each do |subreddit|
        mailing_list = MailingList.find_or_create_by(_id: subreddit)
        mailing_list.insert_email user_activated._id
      end
    end
  end

  factory :user_no_subscription, :parent => :user do
    is_active true
    subreddits blank 
    sequence(:token) { |n| "#{n}" }
  end

  factory :user_deactivated, :parent => :user do
    is_active false 
    sequence(:token) { |n| "#{n}" }
  end
end
