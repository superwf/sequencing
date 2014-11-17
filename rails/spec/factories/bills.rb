FactoryGirl.define do
  factory :bill do
    number 1
    sequence :sn do |n|
      "sn#{n}"
    end
    money 1
    other_money 1
    invoice 'abc'
    status 'df'
    create_date ::Date.today
    creator_id 1
  end
end
