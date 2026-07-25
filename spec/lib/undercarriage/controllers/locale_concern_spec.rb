# frozen_string_literal: true

require "rails_helper"

# spec/requests/greetings_spec.rb covers the end-to-end request cycle (real routing, real
# `around_action`). This tests LocaleConcern's parsing/fallback/rtl-detection logic directly
# against a bare class, so edge cases don't require adding locale files or routes to the dummy app.
RSpec.describe Undercarriage::Controllers::LocaleConcern do
  subject(:instance) do
    dummy_class.new.tap { |i| i.request = fake_request }
  end

  let(:dummy_class) do
    Class.new do
      def self.helper_method(*); end
      def self.around_action(*); end

      include Undercarriage::Controllers::LocaleConcern

      attr_writer :request

      attr_reader :request
    end
  end

  let(:env) { {} }
  let(:fake_request) { double("request", env: env) } # rubocop:disable RSpec/VerifiedDoubles

  describe "#html_lang" do
    it "returns the current I18n locale as a string" do
      allow(I18n).to receive(:locale).and_return(:ar)

      expect(instance.html_lang).to eq("ar")
    end
  end

  describe "#html_dir" do
    # Stubbing I18n.locale (rather than actually setting it via I18n.locale=/with_locale) sidesteps
    # I18n.enforce_available_locales, which would otherwise reject any locale not registered in the
    # dummy app (only `en`/`ar`).
    %w[am ar az dv fa he ur].each do |code|
      it "is `rtl` for `#{code}`" do
        allow(I18n).to receive(:locale).and_return(code.to_sym)

        expect(instance.html_dir).to eq("rtl")
      end
    end

    it "is `rtl` for a region-qualified rtl code" do
      allow(I18n).to receive(:locale).and_return(:"ar-SA")

      expect(instance.html_dir).to eq("rtl")
    end

    %w[en fr de].each do |code|
      it "is `ltr` for `#{code}`" do
        allow(I18n).to receive(:locale).and_return(code.to_sym)

        expect(instance.html_dir).to eq("ltr")
      end
    end
  end

  describe "#identify_locale (protected)" do
    around { |example| I18n.with_locale(:en) { example.run } }

    it "yields with I18n.locale set to the identified locale for the duration of the block" do
      env["HTTP_ACCEPT_LANGUAGE"] = "ar"
      observed_locale = nil

      instance.send(:identify_locale) { observed_locale = I18n.locale }

      expect(observed_locale).to eq(:ar)
    end

    it "restores the previous locale after the block" do
      env["HTTP_ACCEPT_LANGUAGE"] = "ar"

      instance.send(:identify_locale) { nil }

      expect(I18n.locale).to eq(:en)
    end
  end

  describe "#first_available_locale (private)" do
    before do
      allow(I18n).to receive_messages(available_locales: %i[en ar], default_locale: :en)
    end

    it "returns the preferred language when it is available" do
      env["HTTP_ACCEPT_LANGUAGE"] = "ar"

      expect(instance.send(:first_available_locale)).to eq("ar")
    end

    it "falls back to the default locale when nothing in the header is available" do
      env["HTTP_ACCEPT_LANGUAGE"] = "fr, de"

      expect(instance.send(:first_available_locale)).to eq("en")
    end

    it "falls back to the default locale when no header is sent" do
      expect(instance.send(:first_available_locale)).to eq("en")
    end

    it "prefers header order over q-value weight" do
      # `en` has the higher q-value here, but `ar` is listed first, and `accepted_languages_header`
      # strips q-values entirely rather than sorting by them.
      env["HTTP_ACCEPT_LANGUAGE"] = "ar;q=0.1, en;q=0.9"

      expect(instance.send(:first_available_locale)).to eq("ar")
    end

    it "prefers an earlier unavailable language over a later available one only up to the default fallback" do
      # `fr` (unavailable) is listed before `ar` (available), so `ar` wins over the appended
      # default (`en`) despite `en` being the default locale.
      env["HTTP_ACCEPT_LANGUAGE"] = "fr, ar"

      expect(instance.send(:first_available_locale)).to eq("ar")
    end
  end

  describe "#accepted_languages_header (private)" do
    it "splits a comma-separated header and strips q-values" do
      env["HTTP_ACCEPT_LANGUAGE"] = "en-US,en;q=0.9,ar;q=0.8"

      expect(instance.send(:accepted_languages_header)).to eq(%w[en-US en ar])
    end

    it "strips whitespace around entries" do
      env["HTTP_ACCEPT_LANGUAGE"] = " en-US , en;q=0.9 "

      expect(instance.send(:accepted_languages_header)).to eq(%w[en-US en])
    end

    it "returns an empty array when the header is missing" do
      expect(instance.send(:accepted_languages_header)).to eq([])
    end

    it "returns an empty array when the header is blank" do
      env["HTTP_ACCEPT_LANGUAGE"] = ""

      expect(instance.send(:accepted_languages_header)).to eq([])
    end
  end
end
