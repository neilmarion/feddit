FactoryGirl.define do
  factory :user do
    sequence(:_id) { |n| "user#{n}@email.com" }
    sequence(:activation_token) { |n| "#{n}" }
  end
end
