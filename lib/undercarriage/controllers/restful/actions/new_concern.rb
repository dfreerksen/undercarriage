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
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        #
        module NewConcern
          extend ActiveSupport::Concern

          included do
            before_action :new_resource, only: %i[new]
          end

          ##
          # New action
          #
          # Usage
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
          #
          def new
            nested_resource_pre_build
            nested_resource_build
          end

          protected

          ##
          # New restful action
          #
          # Usage
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
          #     # The `resource_new_content` method can also be overwritten. This method is meant to share content with
          #     # the `create` action
          #     #
          #     # def resource_new_content
          #     #   ...
          #     # end
          #   end
          #
          def new_resource_content
            resource_query = model_class.new

            instance_variable_set("@#{instance_name}", resource_query)
          end

          private

          def new_resource
            @new_resource ||= resource_new_content
          end
        end
      end
    end
  end
end
