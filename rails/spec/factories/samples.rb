# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample do
    name 'a'
    vector_id 1
    fragment ''
    resistance ''
    return_type 'return'
    board_id 0
    hole '01A'
    splice_status ''
    is_through true
    parent_id 1
  end
end
