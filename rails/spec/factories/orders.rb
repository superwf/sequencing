FactoryGirl.define do
  factory :order do
    create_date ::Date.today
    number 1
    sequence :sn do |n|
      "sn#{n}"
    end
    urgent false
    is_test false
    transport_condition ''
    status 'new'
    remark 'abc'
    creator_id 1
  end
end
