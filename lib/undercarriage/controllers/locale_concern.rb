# frozen_string_literal: true

module Undercarriage
  # :nodoc:
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

        helper_method :html_lang, :html_dir
      end

      ##
      # Lang
      #
      # Helper for Views to return the identified language.
      #
      # Usage
      #   <html lang="<%= html_lang %>"> #=> '<html lang="de">'
      #   <html lang="<%= html_lang %>"> #=> '<html lang="de-at">'
      #
      def html_lang
        I18n.locale.to_s
      end

      ##
      # Text direction
      #
      # Helper for Views to return text direction based on locale. Display text left-to-right for all languages but a
      # few languages which should display as right-to-left. Returns `rtl` for the following languages:
      #
      # * Arabic
      # * Aramaic
      # * Azeri
      # * Divehi
      # * Hebrew
      # * Persian/Farsi
      # * Urdu
      #
      # Usage
      #   <html dir="<%= html_dir %>"> #=> <html dir="ltr">
      #   <html dir="<%= html_dir %>"> #=> <html dir="rtl">
      #
      def html_dir
        rtl_languages = %w[am ar az dv fa he ur]

        html_lang.start_with?(*rtl_languages) ? 'rtl' : 'ltr'
      end

      protected

      ##
      # Set I18n locale
      #
      # Set I18n locale for the request
      #
      def identify_locale(&action)
        I18n.with_locale(first_available_locale, &action)
      end

      private

      def first_available_locale
        preferred_locales = (accepted_languages_header << I18n.default_locale.to_s).uniq
        available_locales = I18n.available_locales.map(&:to_s)

        (preferred_locales & available_locales).first
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
