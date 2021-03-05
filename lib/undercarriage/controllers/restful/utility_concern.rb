# frozen_string_literal: true

module Undercarriage
  module Controllers
    module Restful
      module UtilityConcern
        extend ActiveSupport::Concern

        protected

        def controller_name_singular
          controller_name.to_s.singularize
        end

        def model_name
          controller_name_singular
        end

        def model_class
          model_name.classify.constantize
        end

        def instances_name
          controller_name.to_s
        end

        def instance_name
          model_name
        end

        def resource_scope
          model_name.to_sym
        end
      end
    end
  end
end
