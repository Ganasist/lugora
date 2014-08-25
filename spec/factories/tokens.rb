# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
    user nil
    token "MyString"
    credits 1
    redeemed false
  end
end
