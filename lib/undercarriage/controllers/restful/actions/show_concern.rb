# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      # :nodoc:
      module Actions
        ##
        # Show restful action
        #
        # @example Controller
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::Restful::Actions::ShowConcern
        #   end
        module ShowConcern
          extend ActiveSupport::Concern

          included do
            include Undercarriage::Controllers::Restful::Actions::BaseConcern

            before_action :show_resource, only: %i[show]
          end

          ##
          # Show action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the action entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@show_resource` or `@example`
          #     #
          #     # def show
          #     #   ...
          #     # end
          #   end
          def show; end

          protected

          ##
          # Show restful action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the query entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@example`
          #     #
          #     # def show_resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To add authorization through something like Pundit, the following could be used
          #     #
          #     # def show_resource_content
          #     #   super
          #     #
          #     #   authorize @example
          #     # end
          #
          #     ##
          #     # The `resource_content` method can also be overwritten. Be careful with this because the `edit`,
          #     # `update`, and `destroy` actions will also use this method
          #     #
          #     # def resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To change the query for `show` only, override `show_content` instead. The `edit`, `update` and
          #     # `destroy` actions are unaffected
          #     #
          #     # def show_content
          #     #   ...
          #     # end
          #   end
          def show_resource_content
            instance_variable_set("@#{instance_name}", show_content)
          end

          private

          ##
          # Show resource before_action callback
          #
          # Memoizes the resource to be shown into `@show_resource` ahead of the `show` action.
          #
          # @return [Object] the resource to show
          def show_resource
            @show_resource ||= show_resource_content
          end
        end
      end
    end
  end
end
