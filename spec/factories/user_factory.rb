FactoryGirl.define do
  factory :user do
    sequence(:_id) { |n| "user#{n}@email.com" }
  end
end
