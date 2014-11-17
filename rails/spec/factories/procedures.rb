FactoryGirl.define do
  factory :procedure do
    sequence :name do |n|
      "name#{n}"
    end
    record_name 'plasmids'
    remark 'ok'
    flow_type 'sample'
    board 0
  end
end
