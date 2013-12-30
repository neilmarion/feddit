FactoryGirl.define do
  factory :user do
    sequence(:_id) { |n| "user#{n}@email.com" }
  end

  factory :user_activated, :parent => :user do
    is_active true
    token "1234567890"
  end
end
