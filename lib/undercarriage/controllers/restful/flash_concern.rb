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
      # Usage
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::Restful::FlashConcern
      #   end
      #
      #   # config/locales/flash.en.yml
      #   flash:
      #     actions:
      #       create:
      #         notice: "%{resource_name} was successfully created."
      #       update:
      #         notice: "%{resource_name} was successfully updated."
      #       destroy:
      #         notice: "%{resource_name} was successfully destroyed."
      #     posts:
      #       create:
      #         notice: "Your %{downcase_resource_name} was created."
      #       update:
      #         notice_html: "<strong>Huzzah!</strong> Your %{downcase_resource_name} was updated."
      #         notice: "Huzzah! Your %{downcase_resource_name} was updated." # Not used since `notice_html` is defined
      #     things:
      #       destroy:
      #         notice: "Good riddance. That wasn't needed anyway."
      #
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
        def flash_created_message
          flash_message_builder(:create, flash_status_type, 'created')
        end

        ##
        # Flash message for `#update` action
        #
        # Translate update flash message
        #
        def flash_updated_message
          flash_message_builder(:update, flash_status_type, 'updated')
        end

        ##
        # Flash message for `#destroy` action
        #
        # Translate destroy flash message
        #
        def flash_destroyed_message
          flash_message_builder(:destroy, flash_status_type, 'destroyed')
        end

        private

        def flash_message_builder(action, status, past_tense)
          defaults = flash_message_defaults(controller_name_singular_human, action, status, past_tense)
          message = defaults.shift

          I18n.t(message, resource_name: controller_name_singular_human,
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
        #   flash.actions.[ACTION].[STATUS]
        #   English default
        #
        def flash_message_defaults(resource_name, action, status, past_tense)
          controller_with_namespace = [resource_namespace, controller_name].compact.join('.')

          [
            :"flash.#{controller_with_namespace}.#{action}.#{status}_html",
            :"flash.#{controller_with_namespace}.#{action}.#{status}",
            :"flash.#{controller_name}.#{action}.#{status}_html",
            :"flash.#{controller_name}.#{action}.#{status}",
            :"flash.actions.#{action}.#{status}",
            "#{resource_name} was successfully #{past_tense}."
          ]
        end
      end
    end
  end
end
