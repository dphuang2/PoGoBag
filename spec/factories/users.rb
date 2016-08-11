FactoryGirl.define do
  factory :user do
    name { FFaker::Internet.user_name }
    screen_name { FFaker::Internet.user_name }
  end
end
