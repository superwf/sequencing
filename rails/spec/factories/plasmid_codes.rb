FactoryGirl.define do
  factory :plasmid_code do
    sequence :code do |n|
      "code#{n}"
    end
    remark 'rrr'
    available true
    creator_id 1
  end
end
