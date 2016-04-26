FactoryGirl.define do
    factory :workshift do
        start_time '10am'
        end_time '1pm'
        day { ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].sample }
        length 3
    end
end