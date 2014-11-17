FactoryGirl.define do
  factory :precheck_code do
    sequence :code do |n|
      "code#{n}"
    end
    remark 'rrr'
    creator_id 1
    ok true
    available true
  end
end
