# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      ##
      # Location after
      #
      # Redirect locations after create, update or destroy
      #
      # Usage
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::Restful::LocationAfterConcern
      #   end
      #
      module LocationAfterConcern
        extend ActiveSupport::Concern

        protected

        ##
        # Location after create
        #
        # The path of the created resource
        #
        def location_after_create
          resource_id = @create_resource

          resource_path(resource_id)
        end

        ##
        # Location after update
        #
        # The path of the updated resource
        #
        def location_after_update
          resource_id = @update_resource

          resource_path(resource_id)
        end

        ##
        # Location after destroy
        #
        # The path of the resources
        #
        def location_after_destroy
          location_after_save
        end

        ##
        # Location after save
        #
        # The path of the resources
        #
        def location_after_save
          resources_path
        end

        private

        def resource_path(resource, options = {})
          location_path = [resource_namespace, controller_name_singular].compact

          send("#{location_path.join('_')}_path", resource, options)
        end

        def resources_path(options = {})
          location_path = [resource_namespace, controller_name].compact.map(&:to_sym)

          polymorphic_path(location_path, options)
        end
      end
    end
  end
end
