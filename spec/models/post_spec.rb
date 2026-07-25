# frozen_string_literal: true

require "rails_helper"

# See test/dummy/app/models/post.rb
# Covers Undercarriage::Models::PublishedConcern.
RSpec.describe Post, type: :model do
  describe ".published_column" do
    it "defaults to :published_at" do
      expect(described_class.published_column).to eq(:published_at)
    end
  end

  describe ".published" do
    it "returns only records with a non-nil `published_at`" do
      published = described_class.create!(title: "Live", published_at: 1.day.ago)
      described_class.create!(title: "Draft", published_at: nil)

      expect(described_class.published).to contain_exactly(published)
    end
  end

  describe ".unpublished" do
    it "returns only records with a nil `published_at`" do
      described_class.create!(title: "Live", published_at: 1.day.ago)
      unpublished = described_class.create!(title: "Draft", published_at: nil)

      expect(described_class.unpublished).to contain_exactly(unpublished)
    end
  end

  describe "#published?" do
    it "is true when `published_at` is present" do
      post = described_class.new(title: "Live", published_at: Time.current)

      expect(post.published?).to be(true)
    end

    it "is false when `published_at` is blank" do
      post = described_class.new(title: "Draft", published_at: nil)

      expect(post.published?).to be(false)
    end
  end

  describe "#unpublished?" do
    it "is the inverse of #published?" do
      published = described_class.new(title: "Live", published_at: Time.current)
      unpublished = described_class.new(title: "Draft", published_at: nil)

      expect(published.unpublished?).to be(false)
      expect(unpublished.unpublished?).to be(true)
    end
  end

  describe "with a custom `published_column`" do
    before { described_class.published_column = :ready_at }

    after { described_class.published_column = :published_at }

    it "scopes and predicates follow the configured column instead of `published_at`" do
      # `published_at` is deliberately set the opposite way on each record to prove the scopes
      # and predicates below are reading `ready_at`, not falling back to the default column.
      ready = described_class.create!(title: "Ready", ready_at: 1.day.ago, published_at: nil)
      not_ready = described_class.create!(title: "Not ready", ready_at: nil, published_at: 1.day.ago)

      expect(described_class.published).to contain_exactly(ready)
      expect(described_class.unpublished).to contain_exactly(not_ready)
      expect(ready.published?).to be(true)
      expect(not_ready.published?).to be(false)
    end
  end
end
