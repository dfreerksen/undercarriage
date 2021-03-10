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
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::Restful::Actions::BaseConcern
        #   end
        #
        module BaseConcern
          extend ActiveSupport::Concern

          protected

          ##
          # New content action
          #
          # Decide what content to load based on action name
          #
          def resource_new_content
            action_name == 'new' ? new_resource_content : create_resource_content
          end

          ##
          # Resource action
          #
          # Used for `show`, `edit`, `update` and `destroy` actions unless overwritten
          #
          # Usage
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
          #
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
          # Usage
          #   nested_resource_pre_build
          #     @example.build_image if @example.image.blank?
          #   end
          #
          def nested_resource_pre_build; end

          ##
          # Build nested association for action
          #
          # Similar to `nested_resource_pre_build` but called in different places. For the `new` and `edit` actions, it
          # is called right after `nested_resource_pre_build`. For the `create` and `update` actions, it is only called
          # after validation has failed and before the view is rendered.
          #
          # Usage
          #   nested_resource_build
          #     @example.build_image if @example.image.blank?
          #   end
          #
          def nested_resource_build; end

          ##
          # After create callback
          #
          # Callback after `create` action has created the record.
          #
          # Usage
          #   after_create_action
          #     ExampleJob.perform_later(@example.id)
          #   end
          #
          def after_create_action; end

          ##
          # After update callback
          #
          # Callback after `update` action has updated the record.
          #
          # Usage
          #   after_update_action
          #     ExampleJob.perform_later(@example.id)
          #   end
          #
          def after_update_action; end
        end
      end
    end
  end
end
