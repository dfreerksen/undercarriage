# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      ##
      # Flash
      #
      # Flash messages
      #
      # FlashConcern is not meant to be included alone
      #
      # I18n - config/locales/flash.en.yml:
      #
      #    flash:
      #       actions:
      #         create:
      #           notice: "%{resource_name} was successfully created."
      #         update:
      #           notice: "%{resource_name} was successfully updated."
      #         destroy:
      #           notice: "%{resource_name} was successfully destroyed."
      #       posts:
      #         create:
      #           notice: "Your %{downcase_resource_name} was created."
      #         update:
      #           notice_html: "<strong>Huzzah!</strong> Your %{downcase_resource_name} was updated."
      #           notice: "Huzzah! Your %{downcase_resource_name} was updated."
      #       things:
      #         destroy:
      #           notice: "Good riddance. That wasn't needed anyway."
      #
      # @example Controller
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::RestfulConcern
      #   end
      module FlashConcern
        extend ActiveSupport::Concern

        included do
          class_attribute :flash_status_type
          self.flash_status_type = :success
        end

        protected

        ##
        # Flash message for `#create` action
        #
        # Translate create flash message
        #
        # @return [String] translation
        def flash_created_message
          flash_message_builder(:create, flash_status_type, "created")
        end

        ##
        # Flash message for `#update` action
        #
        # Translate update flash message
        #
        # @return [String] translation
        def flash_updated_message
          flash_message_builder(:update, flash_status_type, "updated")
        end

        ##
        # Flash message for `#destroy` action
        #
        # Translate destroy flash message
        #
        # @return [String] translation
        def flash_destroyed_message
          flash_message_builder(:destroy, flash_status_type, "destroyed")
        end

        private

        ##
        # Flash message builder
        #
        # Builds and translates the flash message for the given action, looking up translations through
        # `flash_message_defaults`'s fallback chain.
        #
        # @param action [Symbol] the controller action (`:create`, `:update`, `:destroy`)
        # @param status [Symbol] the flash status type (e.g. `:success`)
        # @param past_tense [String] past-tense verb used in the hardcoded English fallback
        # @return [String] translated flash message
        def flash_message_builder(action, status, past_tense)
          defaults = flash_message_defaults(controller_name_singular_title, action, status, past_tense)
          message = defaults.shift

          I18n.t(message, resource_name: controller_name_singular_title,
                          downcase_resource_name: controller_name_singular,
                          default: defaults)
        end

        ##
        # Default flash messages
        #
        # List of default flash messages. The following is the list
        #
        #   flash.[NAMESPACE].[CONTROLLER].[ACTION].[STATUS]_html
        #   flash.[NAMESPACE].[CONTROLLER].[ACTION].[STATUS]
        #   flash.[CONTROLLER].[ACTION].[STATUS]_html
        #   flash.[CONTROLLER].[ACTION].[STATUS]
        #   flash.actions.[ACTION].[STATUS]_html
        #   flash.actions.[ACTION].[STATUS]
        #   English default
        #
        # @return [Array] possible translation paths
        def flash_message_defaults(resource_name, action, status, past_tense)
          controller_with_namespace = [resource_namespace, controller_name].compact.join(".")

          [
            :"flash.#{controller_with_namespace}.#{action}.#{status}_html",
            :"flash.#{controller_with_namespace}.#{action}.#{status}",
            :"flash.#{controller_name}.#{action}.#{status}_html",
            :"flash.#{controller_name}.#{action}.#{status}",
            :"flash.actions.#{action}.#{status}_html",
            :"flash.actions.#{action}.#{status}",
            "#{resource_name} was successfully #{past_tense}."
          ]
        end
      end
    end
  end
end
