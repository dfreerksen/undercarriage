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
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        #
        module CreateConcern
          extend ActiveSupport::Concern

          included do
            before_action :create_resource, only: %i[create]
          end

          ##
          # Create action
          #
          # Usage
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
          #
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

                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @create_resource.errors, status: :unprocessable_entity }
              end
            end
          end

          protected

          ##
          # Create restful action
          #
          # Usage
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
          #     # The `resource_new_content` method can also be overwritten. This method is meant to share content with
          #     # the `new` action
          #     #
          #     # def resource_new_content
          #     #   ...
          #     # end
          #   end
          #
          def create_resource_content
            resource_query = model_class.new(create_resource_params)

            instance_variable_set("@#{instance_name}", resource_query)
          end

          private

          def create_resource
            @create_resource ||= resource_new_content
          end
        end
      end
    end
  end
end
