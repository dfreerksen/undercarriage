# frozen_string_literal: true

module Undercarriage
  module Controllers
    ##
    # Identify locale for translations
    #
    # Identify locale based on `HTTP_ACCEPT_LANGUAGE`. Browser preferred language is passed with the request as
    # `en-US, en;q=0.9` where `en-US` (English with US dialect) is the preferred language with `en` (generic English) as
    # an acceptable language.
    #
    # When preferred language cannot be identified or no translation is available, fall back to `I18n.default_locale`
    # (typically `en`).
    #
    # Usage
    #   class ExamplesController < ApplicationController
    #     include Undercarriage::Controllers::LocaleConcern
    #   end
    #
    module LocaleConcern
      extend ActiveSupport::Concern

      included do
        around_action :identify_locale
      end

      protected

      def identify_locale(&action)
        I18n.with_locale(first_available_locale, &action)
      end

      private

      def first_available_locale
        preferred_locales = (accepted_languages_header << I18n.default_locale.to_s).uniq
        available_locales = I18n.available_locales.map(&:to_s)

        preferred_locales.intersection(available_locales).first
      end

      def accepted_languages_header
        accepted_languages = request.env['HTTP_ACCEPT_LANGUAGE'] || ''

        accepted_languages.gsub(/\s+/, '').split(',').map do |lang|
          lang.split(';q=').first
        end
      end
    end
  end
end
