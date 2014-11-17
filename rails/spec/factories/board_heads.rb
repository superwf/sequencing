FactoryGirl.define do
  factory :board_head do
    sequence :name do |n|
      "name#{n}"
    end
    remark ''
    board_type 'sample'
    cols '1,2,3'
    rows 'A,B,C'
    with_date true
    available true
    is_redo false
  end
end
