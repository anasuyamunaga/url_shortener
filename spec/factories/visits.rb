FactoryBot.define do
  factory :visit do
    link
    visited_at { Time.current }
    user_agent { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/123.0" }
    referrer   { "https://example.com" }
    ip_digest  { Digest::SHA256.hexdigest("test-ip-#{rand(1000)}") }
    bot        { false }

    trait :bot do
      user_agent { "Googlebot/2.1 (+http://www.google.com/bot.html)" }
      bot        { true }
    end

    trait :no_referrer do
      referrer { nil }
    end
  end
end
