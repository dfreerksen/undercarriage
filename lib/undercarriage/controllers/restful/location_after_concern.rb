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
      # LocationAfterConcern is not meant to be included alone
      #
      # @example Controller
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::RestfulConcern
      #   end
      module LocationAfterConcern
        extend ActiveSupport::Concern

        protected

        ##
        # Location after create
        #
        # The path of the created resource
        #
        # @return [String] path after create redirect
        def location_after_create
          resource_id = @create_resource

          resource_path(resource_id)
        end

        ##
        # Location after update
        #
        # The path of the updated resource
        #
        # @return [String] path after update redirect
        def location_after_update
          resource_id = @update_resource

          resource_path(resource_id)
        end

        ##
        # Location after destroy
        #
        # The path of the resources
        #
        # @return [String] path after destroy redirect
        def location_after_destroy
          location_after_save
        end

        ##
        # Location after save
        #
        # The path of the resources
        #
        # @return [String] generic path after save redirect
        def location_after_save
          resources_path
        end

        private

        ##
        # Resource path
        #
        # The path for a single resource, honoring any inferred admin/nested namespace.
        #
        # @param resource [Object] resource to build the path for
        # @param options [Hash] additional options forwarded to the path helper
        # @return [String] resource path
        def resource_path(resource, options = {})
          location_path = [resource_namespace, controller_name_singular].compact

          send("#{location_path.join('_')}_path", resource, options)
        end

        ##
        # Resources path
        #
        # The path for the resource collection, honoring any inferred admin/nested namespace.
        #
        # @param options [Hash] additional options forwarded to `polymorphic_path`
        # @return [String] resources path
        def resources_path(options = {})
          location_path = [resource_namespace, controller_name].compact.map(&:to_sym)

          polymorphic_path(location_path, options)
        end
      end
    end
  end
end
