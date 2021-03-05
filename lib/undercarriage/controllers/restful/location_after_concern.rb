# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      module LocationAfterConcern
        extend ActiveSupport::Concern

        protected

        def location_after_create
          resource_id = @create_resource

          resource_path(resource_id)
        end

        def location_after_update
          resource_id = @update_resource

          resource_path(resource_id)
        end

        def location_after_destroy
          location_after_save
        end

        def location_after_save
          resources_path
        end

        private

        def resource_path(resource, options = {})
          location_path = [resource_namespace, controller_name_singular].compact

          send("#{location_path.join('_')}_path", resource, options)
        end

        def resources_path(options = {})
          location_path = [resource_namespace, controller_name].compact

          polymorphic_path(location_path, options)
        end
      end
    end
  end
end
