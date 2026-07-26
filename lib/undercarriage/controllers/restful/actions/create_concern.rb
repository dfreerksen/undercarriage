# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      # :nodoc:
      module Actions
        ##
        # Create restful action
        #
        # @example Controller
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::Restful::Actions::CreateConcern
        #   end
        module CreateConcern
          extend ActiveSupport::Concern

          included do
            include Undercarriage::Controllers::Restful::Actions::BaseConcern

            before_action :create_resource, only: %i[create]
          end

          ##
          # Create action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the action entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@create_resource` or `@example`
          #     #
          #     # def create
          #     #   ...
          #     # end
          #   end
          def create
            nested_resource_pre_build

            respond_to do |format|
              if @create_resource.save
                after_create_action

                format.html do
                  flash[flash_status_type] = flash_created_message

                  redirect_to location_after_create
                end
                format.json { render :show, status: :created, location: location_after_create }
              else
                nested_resource_build

                format.html { render :new, status: unprocessable_status }
                format.json { render json: @create_resource.errors, status: unprocessable_status }
              end
            end
          end

          protected

          ##
          # Create resource content
          #
          # @return [Object] the built resource
          def create_content
            resource_scope.new(create_resource_params)
          end

          ##
          # Create restful action
          #
          # @example Controller
          #   class ExamplesController < ApplicationController
          #     include Undercarriage::Controllers::RestfulConcern
          #
          #     ##
          #     # This method is only needed if you want to override the query entirely. Otherwise, it is not needed.
          #     # Database resources can be accessed as `@example`
          #     #
          #     # def create_resource_content
          #     #   ...
          #     # end
          #
          #     ##
          #     # To add authorization through something like Pundit, the following could be used
          #     #
          #     # def create_resource_content
          #     #   super
          #     #
          #     #   authorize @example
          #     # end
          #
          #     ##
          #     # To change the underlying build without touching instance variable assignment, override
          #     # `create_content` instead. Note this is independent from `new_content` (`create` no longer shares
          #     # this method with `new`)
          #     #
          #     # def create_content
          #     #   ...
          #     # end
          #   end
          def create_resource_content
            resource_query = create_content

            instance_variable_set("@#{instance_name}", resource_query)
          end

          private

          ##
          # Create resource before_action callback
          #
          # Memoizes the built resource into `@create_resource` ahead of the `create` action.
          #
          # @return [Object] the built resource
          def create_resource
            @create_resource ||= create_resource_content
          end
        end
      end
    end
  end
end
