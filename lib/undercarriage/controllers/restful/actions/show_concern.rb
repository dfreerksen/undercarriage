# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      module Actions
        ##
        # Show restful action
        #
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        #
        module ShowConcern
          extend ActiveSupport::Concern

          included do
            before_action :show_resource, only: %i[show]
          end

          ##
          # Show action
          #
          # Usage
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
          #
          def show
            respond_with(@show_resource) do |format|
              format.html { render layout: !request.xhr? }
              format.json { render layout: false }
            end
          end

          protected

          ##
          # Show restful action
          #
          # Usage
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
          #   end
          #
          def show_resource_content
            resource_content
          end

          private

          def show_resource
            @show_resource ||= show_resource_content
          end
        end
      end
    end
  end
end
