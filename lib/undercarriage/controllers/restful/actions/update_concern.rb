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
        # @example Controller
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::Restful::Actions::UpdateConcern
        #   end
        module UpdateConcern
          extend ActiveSupport::Concern

          included do
            include Undercarriage::Controllers::Restful::Actions::BaseConcern

            before_action :update_resource, only: %i[update]
          end

          ##
          # Update action
          #
          # @example Controller
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
          def update
            nested_resource_pre_build

            respond_to do |format|
              if @update_resource.update(update_resource_params)
                after_update_action

                format.html do
                  flash[flash_status_type] = flash_updated_message

                  redirect_to location_after_update
                end
                format.json { render :show, status: :ok, location: location_after_update }
              else
                nested_resource_build

                format.html { render :edit, status: unprocessable_status }
                format.json { render json: @update_resource.errors, status: unprocessable_status }
              end
            end
          end

          protected

          ##
          # Update restful action
          #
          # @example Controller
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
          #
          #     ##
          #     # To change the query for `update` only, override `update_content` instead. The `show`, `edit` and
          #     # `destroy` actions are unaffected
          #     #
          #     # def update_content
          #     #   ...
          #     # end
          #   end
          def update_resource_content
            instance_variable_set("@#{instance_name}", update_content)
          end

          private

          ##
          # Update resource before_action callback
          #
          # Memoizes the resource to be updated into `@update_resource` ahead of the `update` action.
          #
          # @return [Object] the resource to update
          def update_resource
            @update_resource ||= update_resource_content
          end
        end
      end
    end
  end
end
