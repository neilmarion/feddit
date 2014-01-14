FactoryGirl.define do
  factory :topic do
    sequence(:_id) { |n| "r/comments/#{n}" }
    sequence(:subreddit) { |n| "#{n}" }
    sequence(:author) { |n| "#{n}" }
    sequence(:thumbnail) { |n| "#{n}" }
    sequence(:title) { |n| "#{n}" }
    sequence(:ups) { |n| "#{n}" }
  end
end
