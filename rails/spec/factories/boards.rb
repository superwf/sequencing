FactoryGirl.define do
  factory :board do
    create_date ::Date.today
    sequence :sn do |n|
      "sn#{n}"
    end
    procedure_id 0
    number 1
    status 'ok'
  end
end
