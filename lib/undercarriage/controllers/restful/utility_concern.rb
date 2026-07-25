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
      # UtilityConcern is not meant to be included alone
      #
      # @example Controller
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::RestfulConcern
      #   end
      module UtilityConcern
        extend ActiveSupport::Concern

        protected

        ##
        # Singular controller name
        #
        # @return [String] singular controller name
        def controller_name_singular
          controller_name.to_s.singularize
        end

        ##
        # Titleized controller name
        #
        # @return [String] titelized controller name
        def controller_name_singular_title
          controller_name_singular.titleize
        end
        alias controller_name_singular_human controller_name_singular_title

        ##
        # Model name
        #
        # @return [String] model name
        def model_name
          controller_name_singular
        end

        ##
        # Model class
        #
        # @return [Object] model class
        def model_class
          model_name.classify.constantize
        end

        ##
        # Model scope
        #
        # @return [Symbol] model scope
        def model_scope
          model_name.to_sym
        end

        ##
        # Instances name
        #
        # @return [String] instances name
        def instances_name
          controller_name.to_s
        end

        ##
        # Instance name
        #
        # @return [String] instance name
        def instance_name
          model_name
        end
      end
    end
  end
end
