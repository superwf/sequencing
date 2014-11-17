# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :prepayment do
    money 1000
    balance 1000
    create_date ::Date.today
    remark 'remark'
    invoice '123444'
    creator_id 1
  end
end
