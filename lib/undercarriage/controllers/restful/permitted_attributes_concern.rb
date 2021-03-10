# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      ##
      # Permitted attributes
      #
      # Usage
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::Restful::PermittedAttributesConcern
      #   end
      #
      module PermittedAttributesConcern
        extend ActiveSupport::Concern

        protected

        ##
        # Permitted attributes for `create` action
        #
        # Permitted attributes for the `create` action. If `create` and `update` do not need to be different, you can
        # still override the `permitted_attributes` method which would be applied to both `create` and `update`.
        #
        # Example
        #   def permitted_create_attributes
        #     %i[thingy dilly whatsit]
        #   end
        #
        #   # Use this method is `create` and `update` do not need different permitted attributes
        #   def permitted_attributes
        #     [
        #       :thingy, :dilly, :whatsit,
        #       { whosits_attributes: %i[id _destroy name] }
        #     ]
        #   end
        #
        def permitted_create_attributes
          permitted_attributes_fallback
        end

        ##
        # Permitted attributes for `update` action
        #
        # Permitted attributes for the `update` action. If `create` and `update` do not need to be different, you can
        # still override the `permitted_attributes` method which would be applied to both `create` and `update`.
        #
        # Example
        #   def permitted_update_attributes
        #     %i[thingy dilly whatsit]
        #   end
        #
        #   # Use this method is `create` and `update` do not need different permitted attributes
        #   def permitted_attributes
        #     [
        #       :thingy, :dilly, :whatsit,
        #       { whosits_attributes: %i[id _destroy name] }
        #     ]
        #   end
        #
        def permitted_update_attributes
          permitted_attributes_fallback
        end

        ##
        # New resource decider
        #
        # For the `new` action, resource params are `nil`. For the `create` action, resource params are the posted
        # params from `create_resource_params` method
        #
        def resource_new_params
          action_name == 'new' ? nil : create_resource_params
        end

        ##
        # Permitted params for `create` action
        #
        # Permitted params for the `create` action scoped to the resource.
        #
        def create_resource_params
          permitted = permitted_create_attributes

          params.require(resource_scope).permit(permitted)
        end

        ##
        # Permitted params for `update` action
        #
        # Permitted params for the `update` action scoped to the resource.
        #
        def update_resource_params
          permitted = permitted_update_attributes

          params.require(resource_scope).permit(permitted)
        end

        private

        def permitted_attributes_fallback
          with_method = self.class.instance_methods(false).include?(:permitted_attributes)

          with_method ? permitted_attributes : []
        end
      end
    end
  end
end
