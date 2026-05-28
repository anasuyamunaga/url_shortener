FactoryBot.define do
  factory :link do
    name       { Faker::Lorem.words(number: 3).join(" ").titleize }
    target_url { Faker::Internet.url(scheme: "https") }
    slug       { nil } # triggers auto-generation via before_validation

    trait :with_visits do
      after(:create) do |link|
        create_list(:visit, 3, link: link)
      end
    end

    trait :with_bot_visit do
      after(:create) do |link|
        create(:visit, :bot, link: link)
      end
    end
  end
end
