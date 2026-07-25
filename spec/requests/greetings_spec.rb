# frozen_string_literal: true

require "rails_helper"

# See test/dummy/app/controllers/greetings_controller.rb
RSpec.describe "GreetingsController", type: :request do
  describe "GET /greetings" do
    it "uses the preferred language from Accept-Language when available" do
      get "/greetings", headers: { "Accept-Language" => "ar" }

      expect(response.body).to eq("lang=ar dir=rtl")
    end

    it "falls back to the default locale when no language is accepted" do
      get "/greetings", headers: { "Accept-Language" => "xx" }

      expect(response.body).to eq("lang=en dir=ltr")
    end

    it "falls back to the default locale when no header is sent" do
      get "/greetings"

      expect(response.body).to eq("lang=en dir=ltr")
    end
  end
end
