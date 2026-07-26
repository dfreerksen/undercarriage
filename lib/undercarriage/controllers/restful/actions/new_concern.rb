# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      # :nodoc:
      module Actions
        ##
        # New restful action
        #
        # @example Controller
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::Restful::Actions::NewConcern
        #   end
        module NewConcern
          extend ActiveSupport::Concern

          included do
            include Undercarriage::Controllers::Restful::Actions::BaseConcern

            before_action :new_resource, only: %i[new]
          end

          ##
          # New action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the action entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@new_resource` or `@example`
          #     #
          #     # def new
          #     #   ...
          #     # end
          #   end
          def new
            nested_resource_pre_build
            nested_resource_build
          end

          protected

          ##
          # New resource content
          #
          # @return [Object] the built resource
          def new_content
            resource_scope.new
          end

          ##
          # New restful action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the query entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@example`
          #     #
          #     # def new_resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To add authorization through something like Pundit, the following could be used
          #     #
          #     # def new_resource_content
          #     #   super
          #     #
          #     #   authorize @example
          #     # end
          #
          #     ##
          #     # To change the underlying build without touching instance variable assignment, override
          #     # `new_content` instead. Note this is independent from `create_content` (`create` no longer shares
          #     # this method with `new`)
          #     #
          #     # def new_content
          #     #   ...
          #     # end
          #   end
          def new_resource_content
            resource_query = new_content

            instance_variable_set("@#{instance_name}", resource_query)
          end

          private

          ##
          # New resource before_action callback
          #
          # Memoizes the built resource into `@new_resource` ahead of the `new` action.
          #
          # @return [Object] the built resource
          def new_resource
            @new_resource ||= new_resource_content
          end
        end
      end
    end
  end
end
