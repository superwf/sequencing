# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :prepayment_record do
    create_date ::Date.today
    money 100
    creator_id 1
    remark 'aaabbb'
  end
end
