FactoryGirl.define do
    factory :user do
        sequence(:name)        {|n| "Rainbow_#{n}"}         
        sequence(:email)       {|n| "rain_#{n}@example.com"}
        password               "foobar"
        password_confirmation  "foobar"

        factory :admin do
            admin true
        end
    end
    factory :micropost do
        user
        content "南溪没有卡仕达"
    end
end