# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      module PermittedAttributesConcern
        extend ActiveSupport::Concern

        protected

        def permitted_create_attributes
          permitted_attributes_fallback
        end

        def permitted_update_attributes
          permitted_attributes_fallback
        end

        def resource_new_params
          action_name == 'new' ? nil : create_resource_params
        end

        def create_resource_params
          permitted = permitted_create_attributes

          params.require(resource_scope).permit(permitted)
        end

        def update_resource_params
          permitted = permitted_update_attributes

          params.require(resource_scope).permit(permitted)
        end

        private

        def permitted_attributes_fallback
          with_method = self.class.instance_methods(false)
                            .include?(:permitted_attributes)

          with_method ? permitted_attributes : []
        end
      end
    end
  end
end
