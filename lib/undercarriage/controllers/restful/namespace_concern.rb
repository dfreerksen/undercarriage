# frozen_string_literal: true

module Undercarriage
  # :nodoc:
  module Controllers
    # :nodoc:
    module Restful
      ##
      # Namespace
      #
      # NamespaceConcern is not meant to be included alone
      #
      # @example Controller
      #   class ExamplesController < ApplicationController
      #     include Undercarriage::Controllers::RestfulConcern
      #   end
      module NamespaceConcern
        extend ActiveSupport::Concern

        protected

        ##
        # Resource namespace
        #
        # Best guess for namespace. Take `controller_path` and if there is more than one segment, assume the first is
        # the namespace. When there is one segment, the namespace is `nil`
        #
        # @example Controller
        #   # Override method that builds namespace
        #   def resource_namespace
        #     :admin
        #   end
        def resource_namespace
          segments = controller_path.split("/")

          segments.length > 1 ? segments.first : nil
        end
      end
    end
  end
end
