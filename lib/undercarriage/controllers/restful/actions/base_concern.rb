# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      module Actions
        ##
        # Base restful action
        #
        # Usage
        #   class ExamplesController < ApplicationController
        #     include Undercarriage::Controllers::RestfulConcern
        #   end
        #
        module BaseConcern
          extend ActiveSupport::Concern

          protected

          def resource_new_content
            action_name == 'new' ? new_resource_content : create_resource_content
          end

          def resource_content
            resource_id = params.fetch(:id)
            resource_query = model_class.find(resource_id)

            instance_variable_set("@#{instance_name}", resource_query)
          end

          def nested_resource_pre_build; end

          def nested_resource_build; end

          def after_create_action; end

          def after_update_action; end
        end
      end
    end
  end
end
