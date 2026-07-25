# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      # :nodoc:
      module Actions
        ##
        # Base restful action
        #
        # BaseConcern is not meant to be included alone
        #
        # @example Controller
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        module BaseConcern
          extend ActiveSupport::Concern

          included do
            include Undercarriage::Controllers::Restful::FlashConcern
            include Undercarriage::Controllers::Restful::LocationAfterConcern
            include Undercarriage::Controllers::Restful::NamespaceConcern
            include Undercarriage::Controllers::Restful::PermittedAttributesConcern
            include Undercarriage::Controllers::Restful::UtilityConcern
          end

          protected

          ##
          # Resource scope
          #
          # @return [Object] resource class scope
          def resource_scope
            model_class
          end

          ##
          # New content action
          #
          # Decide what content to load based on action name
          #
          # @return [Object,Hash]
          def resource_new_content
            action_name == "new" ? new_resource_content : create_resource_content
          end

          ##
          # Resource action
          #
          # Used for `show`, `edit`, `update` and `destroy` actions unless overwritten
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the query entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@example`
          #     #
          #     # def resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To add authorization through something like Pundit, the following could be used
          #     #
          #     # def resource_content
          #     #   super
          #     #
          #     #   authorize @example
          #     # end
          #   end
          def resource_content
            resource_id = params.fetch(:id)
            resource_query = model_class.find(resource_id)

            instance_variable_set("@#{instance_name}", resource_query)
          end

          ##
          # Build nested association before action
          #
          # Called first thing from `new`, `create`, `edit` and `update` actions. Meant to build a basic resource before
          # the action is evaluated
          #
          # @example Controller
          #   def nested_resource_pre_build
          #     @example.build_image if @example.image.blank?
          #   end
          def nested_resource_pre_build; end

          ##
          # Build nested association for action
          #
          # Similar to `nested_resource_pre_build` but called in different places. For the `new` and `edit` actions, it
          # is called right after `nested_resource_pre_build`. For the `create` and `update` actions, it is only called
          # after validation has failed and before the view is rendered.
          #
          # @example Controller
          #   def nested_resource_build
          #     @example.build_image if @example.image.blank?
          #   end
          def nested_resource_build; end

          ##
          # After create callback
          #
          # Callback after `create` action has created the record.
          #
          # @example Controller
          #   def after_create_action
          #     ExampleJob.perform_later(@example.id)
          #   end
          def after_create_action; end

          ##
          # After update callback
          #
          # Callback after `update` action has updated the record.
          #
          # @example Controller
          #   def after_update_action
          #     ExampleJob.perform_later(@example.id)
          #   end
          def after_update_action; end

          ##
          # Unprocessable status
          #
          # Rack 3.1 (bundled with Rails >= 8.0) renamed the RFC 9110-aligned `422` status symbol from
          # `:unprocessable_entity` (now deprecated) to `:unprocessable_content`. Rails < 8.0 doesn't know the new
          # name, so pick whichever symbol the currently loaded Rails understands.
          #
          # @return [Symbol] unprocessable status type
          def unprocessable_status
            Rails::VERSION::MAJOR >= 8 ? :unprocessable_content : :unprocessable_entity
          end
        end
      end
    end
  end
end
