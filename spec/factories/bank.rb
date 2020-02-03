FactoryBot.define do
    factory :bank do
        name { Faker::Lorem.word }
        state { Faker::Lorem.word }
    end
end