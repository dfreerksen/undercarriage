# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      ##
      # Permitted attributes
      #
      # PermittedAttributesConcern is not meant to be included alone
      #
      # @example Controller
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::RestfulConcern
      #   end
      module PermittedAttributesConcern
        extend ActiveSupport::Concern

        protected

        ##
        # Permitted attributes for `create` action
        #
        # Permitted attributes for the `create` action. If `create` and `update` do not need to be different, you can
        # still override the `permitted_attributes` method which would be applied to both `create` and `update`.
        #
        # @return [Array,Hash] permitted create attributes
        #
        # @example Controller
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
        def permitted_create_attributes
          permitted_attributes_fallback
        end

        ##
        # Permitted attributes for `update` action
        #
        # Permitted attributes for the `update` action. If `create` and `update` do not need to be different, you can
        # still override the `permitted_attributes` method which would be applied to both `create` and `update`.
        #
        # @return [Array,Hash] permitted update attributes
        #
        # @example Controller
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
        def permitted_update_attributes
          permitted_attributes_fallback
        end

        ##
        # New resource decider
        #
        # For the `new` action, resource params are `nil`. For the `create` action, resource params are the posted
        # params from `create_resource_params` method
        #
        # @return [Array,Hash,nil] permitted new attributes
        def resource_new_params
          action_name == "new" ? nil : create_resource_params
        end

        ##
        # Permitted params for `create` action
        #
        # Permitted params for the `create` action scoped to the resource.
        def create_resource_params
          permitted = permitted_create_attributes

          params.require(model_scope).permit(permitted)
        end

        ##
        # Permitted params for `update` action
        #
        # Permitted params for the `update` action scoped to the resource.
        def update_resource_params
          permitted = permitted_update_attributes

          params.require(model_scope).permit(permitted)
        end

        private

        ##
        # Permitted attributes fallback
        #
        # Falls back to the controller's `permitted_attributes` method, if defined, when
        # `permitted_create_attributes`/`permitted_update_attributes` are not individually overridden.
        #
        # @return [Array,Hash] permitted attributes, or an empty array if `permitted_attributes` is not defined
        def permitted_attributes_fallback
          with_method = self.class.method_defined?(:permitted_attributes)

          with_method ? permitted_attributes : []
        end
      end
    end
  end
end
