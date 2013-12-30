FactoryGirl.define do
  factory :user do
    sequence(:_id) { |n| "user#{n}@email.com" }
  end

  factory :user_activated, :parent => :user do
    is_active true
    sequence(:token) { |n| "#{n}" }
  end

  factory :user_deactivated, :parent => :user do
    is_active false 
    sequence(:token) { |n| "#{n}" }
  end
end
