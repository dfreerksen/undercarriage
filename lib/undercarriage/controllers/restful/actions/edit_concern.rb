# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      module Actions
        ##
        # Edit restful action
        #
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        #
        module EditConcern
          extend ActiveSupport::Concern

          included do
            before_action :edit_resource, only: %i[edit]
          end

          ##
          # Edit action
          #
          # Usage
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
          #
          def edit
            nested_resource_pre_build
            nested_resource_build

            respond_with(@edit_resource) do |format|
              format.html { render layout: !request.xhr? }
            end
          end

          protected

          ##
          # Edit restful action
          #
          # Usage
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
          #   end
          #
          def edit_resource_content
            resource_content
          end

          private

          def edit_resource
            @edit_resource ||= edit_resource_content
          end
        end
      end
    end
  end
end
