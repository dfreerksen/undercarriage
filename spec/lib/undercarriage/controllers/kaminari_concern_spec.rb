# frozen_string_literal: true

require "rails_helper"

# spec/requests/posts_spec.rb covers the end-to-end pagination behavior (real Kaminari `.page`/`.per`
# call through PostsController). This tests KaminariConcern's own param parsing/defaulting logic
# directly against a bare class, independent of Kaminari's own pagination behavior.
RSpec.describe Undercarriage::Controllers::KaminariConcern do
  subject(:instance) { dummy_class.new }

  let(:dummy_class) do
    Class.new do
      def self.helper_method(*names)
        (@helper_methods ||= []).concat(names)
      end

      class << self
        attr_reader :helper_methods
      end

      include Undercarriage::Controllers::KaminariConcern

      attr_writer :params

      attr_reader :params
    end
  end

  describe "included hook" do
    it "exposes page_num and per_page as helper_methods" do
      expect(dummy_class.helper_methods).to contain_exactly(:page_num, :per_page)
    end
  end

  describe "#per_page" do
    it "returns the `per` param as an integer when present" do
      instance.params = { per: "50" }

      expect(instance.per_page).to eq(50)
    end

    it "defaults to Kaminari.config.default_per_page when the param is absent" do
      instance.params = {}

      expect(instance.per_page).to eq(Kaminari.config.default_per_page)
    end

    it "coerces a non-numeric value to the minimum of 1" do
      instance.params = { per: "abc" }

      expect(instance.per_page).to eq(1)
    end

    it "clamps a value above per_page_max down to per_page_max" do
      instance.params = { per: "999999999" }

      expect(instance.per_page).to eq(instance.send(:per_page_max))
    end

    it "clamps a negative value up to the minimum of 1" do
      instance.params = { per: "-1" }

      expect(instance.per_page).to eq(1)
    end
  end

  describe "#page_num" do
    it "returns the page param as an integer when present" do
      instance.params = { Kaminari.config.param_name => "3" }

      expect(instance.page_num).to eq(3)
    end

    it "defaults to 1 when the param is absent" do
      instance.params = {}

      expect(instance.page_num).to eq(1)
    end

    it "coerces a non-numeric value to the minimum of 1" do
      instance.params = { Kaminari.config.param_name => "abc" }

      expect(instance.page_num).to eq(1)
    end

    it "clamps a negative value up to the minimum of 1" do
      instance.params = { Kaminari.config.param_name => "-1" }

      expect(instance.page_num).to eq(1)
    end
  end

  describe "#per_page_key (protected)" do
    it "is :per" do
      expect(instance.send(:per_page_key)).to eq(:per)
    end
  end

  describe "#page_num_key (protected)" do
    it "delegates to Kaminari.config.param_name" do
      expect(instance.send(:page_num_key)).to eq(Kaminari.config.param_name)
    end
  end

  describe "#per_page_max (private)" do
    it "defaults to 100 when Kaminari.config.max_per_page is not set" do
      expect(instance.send(:per_page_max)).to eq(100)
    end
  end
end
