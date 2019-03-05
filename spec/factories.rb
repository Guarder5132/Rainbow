FactoryGirl.define do
    factory :user do
        sequence(:name)        {|n| "Rainbow_#{n}"}         
        sequence(:email)       {|n| "rain_#{n}@example.com"}
        password               "foobar"
        password_confirmation  "foobar"
    end
end