FactoryGirl.define do
  factory :reaction_file do
    uploaded_at Time.now
    code_id 0
    proposal ''
    status 'new'
    interpreter_id 1
    interpreted_at Time.now
  end
end
