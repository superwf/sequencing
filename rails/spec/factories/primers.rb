FactoryGirl.define do
  factory :primer do
    today = ::Date.today
    sequence :name do |n|
      "primer#{n}"
    end
    origin_thickness 1
    annealing ''
    seq ''
    hole '1A'
    status 'new'
    store_type 'ok'
    create_date today
    expire_date today
    operate_date today
    need_return false
    available true
    creator_id 1
    remark 'rrr'
  end
end
