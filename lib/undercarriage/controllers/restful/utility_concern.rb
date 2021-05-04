# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      ##
      # Utility
      #
      # Utility helper methods
      #
      # Usage
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::Restful::UtilityConcern
      #   end
      #
      module UtilityConcern
        extend ActiveSupport::Concern

        protected

        ##
        # Singular controller name
        #
        def controller_name_singular
          controller_name.to_s.singularize
        end

        ##
        # Titleized controller name
        #
        def controller_name_singular_title
          controller_name_singular.titleize
        end
        alias controller_name_singular_human controller_name_singular_title

        ##
        # Model name
        #
        def model_name
          controller_name_singular
        end

        ##
        # Model class
        #
        def model_class
          model_name.classify.constantize
        end

        ##
        # Instances name
        #
        def instances_name
          controller_name.to_s
        end

        ##
        # Instance name
        #
        def instance_name
          model_name
        end

        ##
        # Resource scope
        #
        def resource_scope
          model_name.to_sym
        end
      end
    end
  end
end
