# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      # :nodoc:
      module Actions
        ##
        # Edit restful action
        #
        # @example Controller
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::Restful::Actions::EditConcern
        #   end
        module EditConcern
          extend ActiveSupport::Concern

          included do
            include Undercarriage::Controllers::Restful::Actions::BaseConcern

            before_action :edit_resource, only: %i[edit]
          end

          ##
          # Edit action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the action entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@edit_resource` or `@example`
          #     #
          #     # def edit
          #     #   ...
          #     # end
          #   end
          def edit
            nested_resource_pre_build
            nested_resource_build
          end

          protected

          ##
          # Edit restful action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the query entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@example`
          #     #
          #     # def edit_resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To add authorization through something like Pundit, the following could be used
          #     #
          #     # def edit_resource_content
          #     #   super
          #     #
          #     #   authorize @example
          #     # end
          #
          #     ##
          #     # The `resource_content` method can also be overwritten. Be careful with this because the `show`,
          #     # `update` and `destroy` actions will also use this method
          #     #
          #     # def resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To change the query for `edit` only, override `edit_content` instead. The `show`, `update` and
          #     # `destroy` actions are unaffected
          #     #
          #     # def edit_content
          #     #   ...
          #     # end
          #   end
          def edit_resource_content
            instance_variable_set("@#{instance_name}", edit_content)
          end

          private

          ##
          # Edit resource before_action callback
          #
          # Memoizes the resource to be edited into `@edit_resource` ahead of the `edit` action.
          #
          # @return [Object] the resource to edit
          def edit_resource
            @edit_resource ||= edit_resource_content
          end
        end
      end
    end
  end
end
