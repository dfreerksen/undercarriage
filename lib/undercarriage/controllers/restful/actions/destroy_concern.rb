# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      # :nodoc:
      module Actions
        ##
        # Destroy restful action
        #
        # @example Controller
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::Restful::Actions::DestroyConcern
        #   end
        module DestroyConcern
          extend ActiveSupport::Concern

          included do
            include Undercarriage::Controllers::Restful::Actions::BaseConcern

            before_action :destroy_resource, only: %i[destroy]
          end

          ##
          # Destroy action
          #
          # @example Controller
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
          def destroy
            @destroy_resource.destroy

            respond_to do |format|
              format.html do
                flash[flash_status_type] = flash_destroyed_message

                redirect_to location_after_destroy
              end
              format.json { head :no_content }
            end
          end

          protected

          ##
          # Destroy restful action
          #
          # @example Controller
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
          def destroy_resource_content
            resource_content
          end

          private

          ##
          # Destroy resource before_action callback
          #
          # Memoizes the resource to be destroyed into `@destroy_resource` ahead of the `destroy` action.
          #
          # @return [Object] the resource to destroy
          def destroy_resource
            @destroy_resource ||= destroy_resource_content
          end
        end
      end
    end
  end
end
