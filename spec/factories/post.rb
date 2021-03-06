# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n} Title" }
    body { '<p>Post body.</p>' }
    published_at { nil }

    trait :published do
      published_at { Time.current }
    end

    trait :scheduled do
      published_at { 1.day.from_now }
    end
  end
end
