# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      module Actions
        ##
        # Destroy restful action
        #
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        #
        module DestroyConcern
          extend ActiveSupport::Concern

          included do
            before_action :destroy_resource, only: %i[destroy]
          end

          ##
          # Destroy action
          #
          # Usage
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the action entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@destroy_resource` or `@example`
          #     #
          #     # def destroy
          #     #   ...
          #     # end
          #   end
          #
          def destroy
            @destroy_resource.destroy

            respond_with(@destroy_resource) do |format|
              format.html { redirect_to location_after_destroy }
            end
          end

          protected

          ##
          # Destroy restful action
          #
          # Usage
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the query entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@example`
          #     #
          #     # def destroy_resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To add authorization through something like Pundit, the following could be used
          #     #
          #     # def destroy_resource_content
          #     #   super
          #     #
          #     #   authorize @example
          #     # end
          #
          #     ##
          #     # The `resource_content` method can also be overwritten. Be careful with this because the `show`,
          #     # `edit` and `update` actions will also use this method
          #     #
          #     # def resource_content
          #     #   ...
          #     # end
          #   end
          #
          def destroy_resource_content
            resource_content
          end

          private

          def destroy_resource
            @destroy_resource ||= destroy_resource_content
          end
        end
      end
    end
  end
end
