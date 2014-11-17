# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    name 'c'
    full_name 'c'
    full_code 'c'
    sequence :code do |n|
      n.to_s
    end
    creator_id 1
  end
end
