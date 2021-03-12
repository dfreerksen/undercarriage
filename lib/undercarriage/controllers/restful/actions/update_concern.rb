# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      # :nodoc:
      module Actions
        ##
        # Update restful action
        #
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        #
        module UpdateConcern
          extend ActiveSupport::Concern

          included do
            before_action :update_resource, only: %i[update]
          end

          ##
          # Update action
          #
          # Usage
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the action entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@update_resource` or `@example`
          #     #
          #     # def update
          #     #   ...
          #     # end
          #   end
          #
          def update
            nested_resource_pre_build

            if @update_resource.update(update_resource_params)
              after_update_action

              flash[flash_status_type] = flash_updated_message

              redirect_to location_after_update
            else
              nested_resource_build

              render :edit, status: :unprocessable_entity
            end
          end

          protected

          ##
          # Update restful action
          #
          # Usage
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the query entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@example`
          #     #
          #     # def update_resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To add authorization through something like Pundit, the following could be used
          #     #
          #     # def update_resource_content
          #     #   super
          #     #
          #     #   authorize @example
          #     # end
          #
          #     ##
          #     # The `resource_content` method can also be overwritten. Be careful with this because the `show`,
          #     # `edit` and `destroy` actions will also use this method
          #     #
          #     # def resource_content
          #     #   ...
          #     # end
          #   end
          #
          def update_resource_content
            resource_content
          end

          private

          def update_resource
            @update_resource ||= update_resource_content
          end
        end
      end
    end
  end
end
