# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    sequence :email do |n|
      "a#{n}@b.com"
    end
    name 'client'
    tel '123'
    address 'add'
    remark 'remark'
    creator_id 1
    encrypted_password 'df'
  end
end
